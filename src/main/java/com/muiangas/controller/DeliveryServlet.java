package com.muiangas.controller;

import com.muiangas.dao.CategoriaDAO;
import com.muiangas.dao.DeliveryDAO;
import com.muiangas.dao.ProdutoDAO;
import com.muiangas.model.Cliente;
import com.muiangas.model.PedidoDelivery;
import com.muiangas.model.ZonaDelivery;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.time.LocalTime;
import java.util.UUID;

@WebServlet(name = "DeliveryServlet", urlPatterns = "/delivery")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class DeliveryServlet extends HttpServlet {

    private final DeliveryDAO  deliveryDAO  = new DeliveryDAO();
    private final ProdutoDAO   produtoDAO   = new ProdutoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    private static final int HORA_ABERTURA     = 9;
    private static final int HORA_ENCERRAMENTO = 17;
    static final String MPESA_NUMERO   = "84 XXX XXXX";
    static final String EMOLA_NUMERO   = "84 XXX XXXX";
    static final String PAGAMENTO_NOME = "Muianga's Restaurante";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        carregarAtributos(req);
        req.getRequestDispatcher("/views/public/delivery.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        if (!isAberto()) {
            carregarAtributos(req);
            req.setAttribute("aberto", false);
            req.getRequestDispatcher("/views/public/delivery.jsp").forward(req, resp);
            return;
        }

        try {
            PedidoDelivery p = new PedidoDelivery();

            // ── Se cliente está logado, ligar o pedido à conta ──
            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("cliente") != null) {
                Cliente c = (Cliente) session.getAttribute("cliente");
                p.setClienteId(c.getId());
                // Pré-preencher nome e telefone com dados da conta
                p.setClienteNome(c.getNome());
                p.setClienteTelefone(c.getTelefone() != null ? c.getTelefone() : req.getParameter("telefone"));
            } else {
                p.setClienteNome(req.getParameter("nome"));
                p.setClienteTelefone(req.getParameter("telefone"));
            }

            p.setZonaId(Integer.parseInt(req.getParameter("zonaId")));
            p.setMorada(req.getParameter("morada"));
            p.setObservacoes(req.getParameter("observacoes"));
            p.setItens(req.getParameter("itens"));
            p.setMetodoPagamento(req.getParameter("metodoPagamento"));

            String latStr = req.getParameter("latitude");
            String lngStr = req.getParameter("longitude");
            if (latStr != null && !latStr.isBlank()) p.setLatitude(Double.parseDouble(latStr));
            if (lngStr != null && !lngStr.isBlank()) p.setLongitude(Double.parseDouble(lngStr));

            p.setTotal(new BigDecimal(req.getParameter("total").replace(",", ".")));
            ZonaDelivery zona = deliveryDAO.buscarZonaPorId(p.getZonaId());
            p.setTaxaEntrega(zona != null ? zona.getTaxaEntrega() : BigDecimal.ZERO);

            int idNovo = deliveryDAO.inserirPedido(p);

            // Comprovativo
            Part filePart = req.getPart("comprovativo");
            if (filePart != null && filePart.getSize() > 0) {
                String ext      = obterExtensao(filePart.getSubmittedFileName());
                String nomeFile = "comp_" + idNovo + "_" + UUID.randomUUID().toString().substring(0, 8) + ext;
                String uploadDir = getServletContext().getRealPath("/comprovativos");
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();
                try (InputStream is = filePart.getInputStream()) {
                    Files.copy(is, new File(dir, nomeFile).toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                deliveryDAO.guardarComprovativo(idNovo, nomeFile);
            }

            resp.sendRedirect(req.getContextPath() + "/delivery?sucesso=" + idNovo
                    + "&metodo=" + p.getMetodoPagamento());

        } catch (Exception e) {
            carregarAtributos(req);
            req.setAttribute("erro", "Erro ao registar pedido: " + e.getMessage());
            req.getRequestDispatcher("/views/public/delivery.jsp").forward(req, resp);
        }
    }

    private void carregarAtributos(HttpServletRequest req) {
        try {
            req.setAttribute("produtos",   produtoDAO.listarDisponiveis(0));
            req.setAttribute("zonas",      deliveryDAO.listarZonasAtivas());
            req.setAttribute("categorias", categoriaDAO.listarTodas());
        } catch (Exception e) {
            req.setAttribute("erroServlet", e.getMessage());
        }
        req.setAttribute("aberto",           isAberto());
        req.setAttribute("horaAbertura",     HORA_ABERTURA);
        req.setAttribute("horaEncerramento", HORA_ENCERRAMENTO);
        req.setAttribute("mpesaNumero",      MPESA_NUMERO);
        req.setAttribute("emolaNumero",      EMOLA_NUMERO);
        req.setAttribute("pagamentoNome",    PAGAMENTO_NOME);

        // passar cliente logado para o JSP pré-preencher o form
        HttpSession session = req.getSession(false);
        if (session != null) req.setAttribute("clienteLogado", session.getAttribute("cliente"));
    }

    private boolean isAberto() {
        LocalTime agora = LocalTime.now();
        return !agora.isBefore(LocalTime.of(HORA_ABERTURA, 0)) &&
                agora.isBefore(LocalTime.of(HORA_ENCERRAMENTO, 0));
    }

    private String obterExtensao(String filename) {
        if (filename == null || !filename.contains(".")) return ".jpg";
        return filename.substring(filename.lastIndexOf(".")).toLowerCase();
    }
}

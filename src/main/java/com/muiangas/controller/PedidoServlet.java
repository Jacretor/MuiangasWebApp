package com.muiangas.controller;

import com.muiangas.dao.*;
import com.muiangas.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * Servlet de gestão de pedidos.
 * GET  /admin/pedidos              → lista abertos
 * GET  /admin/pedidos?acao=novo    → form novo pedido
 * POST /admin/pedidos?acao=novo    → criar pedido
 * POST /admin/pedidos?acao=addItem → adicionar item
 * GET  /admin/pedidos?acao=ver&id=X → detalhes
 * GET  /admin/pedidos?acao=fechar&id=X → fechar/pagar
 */
@WebServlet(name = "PedidoServlet", urlPatterns = "/admin/pedidos")
public class PedidoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!autenticado(req, resp)) return;
        String acao = req.getParameter("acao");

        try {
            PedidoDAO pedidoDAO = new PedidoDAO();

            if ("novo".equals(acao)) {
                req.setAttribute("mesasLivres", new MesaDAO().listarLivres());
                req.setAttribute("clientes", new ClienteDAO().listarTodos());
                req.getRequestDispatcher("/views/admin/pedido-novo.jsp").forward(req, resp);

            } else if ("ver".equals(acao)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Pedido p = pedidoDAO.buscarPorId(id);
                req.setAttribute("pedido", p);
                req.setAttribute("produtos", new ProdutoDAO().listarDisponiveis(0));
                req.getRequestDispatcher("/views/admin/pedido-detalhe.jsp").forward(req, resp);

            } else if ("fechar".equals(acao)) {
                pedidoDAO.fecharPedido(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect(req.getContextPath() + "/admin/pedidos?msg=pago");

            } else {
                req.setAttribute("pedidos", pedidoDAO.listarAbertos());
                req.getRequestDispatcher("/views/admin/pedidos.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("erro", "Erro: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/pedidos.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!autenticado(req, resp)) return;
        req.setCharacterEncoding("UTF-8");
        String acao = req.getParameter("acao");

        try {
            PedidoDAO pedidoDAO = new PedidoDAO();
            HttpSession session = req.getSession(false);
            Funcionario func = (Funcionario) session.getAttribute("funcionario");

            if ("novo".equals(acao)) {
                // Criar cliente on-the-fly ou usar existente
                int clienteId;
                String clienteIdStr = req.getParameter("clienteId");
                if (clienteIdStr != null && !clienteIdStr.isBlank() && Integer.parseInt(clienteIdStr) > 0) {
                    clienteId = Integer.parseInt(clienteIdStr);
                } else {
                    Cliente c = new Cliente();
                    c.setNome(req.getParameter("clienteNome"));
                    c.setTelefone(req.getParameter("clienteTelefone"));
                    clienteId = new ClienteDAO().inserir(c);
                }

                Pedido p = new Pedido();
                p.setMesaId(Integer.parseInt(req.getParameter("mesaId")));
                p.setClienteId(clienteId);
                p.setFuncionarioId(func.getId());
                int pedidoId = pedidoDAO.criarPedido(p);

                // Marcar mesa como ocupada
                new MesaDAO().alterarStatus(p.getMesaId(), "ocupada");

                resp.sendRedirect(req.getContextPath() + "/admin/pedidos?acao=ver&id=" + pedidoId);

            } else if ("addItem".equals(acao)) {
                ItemPedido item = new ItemPedido();
                item.setPedidoId(Integer.parseInt(req.getParameter("pedidoId")));
                item.setProdutoId(Integer.parseInt(req.getParameter("produtoId")));
                item.setQuantidade(Integer.parseInt(req.getParameter("quantidade")));
                // Buscar preço actual do produto
                Produto prod = new ProdutoDAO().buscarPorId(item.getProdutoId());
                item.setPrecoUnitario(prod.getPreco());
                pedidoDAO.adicionarItem(item);
                resp.sendRedirect(req.getContextPath() + "/admin/pedidos?acao=ver&id=" + item.getPedidoId());
            }
        } catch (Exception e) {
            req.setAttribute("erro", "Erro: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/pedidos.jsp").forward(req, resp);
        }
    }

    private boolean autenticado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("funcionario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}

package com.muiangas.controller;

import com.muiangas.dao.CategoriaDAO;
import com.muiangas.dao.ProdutoDAO;
import com.muiangas.model.Produto;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.nio.file.*;

@WebServlet(name = "ProdutoServlet", urlPatterns = "/admin/produtos")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 5 * 1024 * 1024,
    maxRequestSize    = 10 * 1024 * 1024
)
public class ProdutoServlet extends HttpServlet {

    private final ProdutoDAO   produtoDAO   = new ProdutoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();
    private static final String PASTA_IMAGENS = "imagens_produtos";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!autenticado(req, resp)) return;
        String acao = req.getParameter("acao");

        try {
            if ("novo".equals(acao)) {
                req.setAttribute("categorias", categoriaDAO.listarTodas());
                req.setAttribute("produto", new Produto());
                req.getRequestDispatcher("/views/admin/produto-form.jsp").forward(req, resp);

            } else if ("editar".equals(acao)) {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("produto", produtoDAO.buscarPorId(id));
                req.setAttribute("categorias", categoriaDAO.listarTodas());
                req.getRequestDispatcher("/views/admin/produto-form.jsp").forward(req, resp);

            } else if ("desactivar".equals(acao)) {
                produtoDAO.desactivar(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect(req.getContextPath() + "/admin/produtos?msg=desactivado");

            } else if ("activar".equals(acao)) {
                produtoDAO.activar(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect(req.getContextPath() + "/admin/produtos?msg=activado");

            } else if ("eliminar".equals(acao)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Produto p = produtoDAO.buscarPorId(id);
                if (produtoDAO.temPedidosAssociados(id)) {
                    // Tem histórico — desactivar em vez de eliminar
                    produtoDAO.desactivar(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/produtos?msg=desactivado");
                } else {
                    if (p != null && p.getImagem() != null) apagarImagem(req, p.getImagem());
                    produtoDAO.eliminar(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/produtos?msg=eliminado");
                }

            } else {
                req.setAttribute("produtos", produtoDAO.listarTodos());
                req.getRequestDispatcher("/views/admin/produtos.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("erro", "Erro: " + e.getMessage());
            try { req.setAttribute("produtos", produtoDAO.listarTodos()); } catch (Exception ignored) {}
            req.getRequestDispatcher("/views/admin/produtos.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!autenticado(req, resp)) return;
        req.setCharacterEncoding("UTF-8");

        try {
            Produto p = new Produto();
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isBlank()) p.setId(Integer.parseInt(idStr));
            p.setNome(req.getParameter("nome"));
            p.setDescricao(req.getParameter("descricao"));
            p.setPreco(new BigDecimal(req.getParameter("preco").replace(",", ".")));
            p.setCategoriaId(Integer.parseInt(req.getParameter("categoriaId")));
            p.setDisponivel("on".equals(req.getParameter("disponivel")));

            Part filePart = req.getPart("imagem");
            if (filePart != null && filePart.getSize() > 0) {
                String nomeImagem = guardarImagem(req, filePart);
                if (p.getId() > 0) {
                    Produto antigo = produtoDAO.buscarPorId(p.getId());
                    if (antigo != null && antigo.getImagem() != null) apagarImagem(req, antigo.getImagem());
                }
                p.setImagem(nomeImagem);
            }

            if (p.getId() > 0) {
                produtoDAO.actualizar(p);
                resp.sendRedirect(req.getContextPath() + "/admin/produtos?msg=actualizado");
            } else {
                produtoDAO.inserir(p);
                resp.sendRedirect(req.getContextPath() + "/admin/produtos?msg=criado");
            }

        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao guardar: " + e.getMessage());
            try { req.setAttribute("categorias", categoriaDAO.listarTodas()); } catch (Exception ignored) {}
            req.getRequestDispatcher("/views/admin/produto-form.jsp").forward(req, resp);
        }
    }

    private String guardarImagem(HttpServletRequest req, Part filePart) throws IOException {
        String pastaReal = req.getServletContext().getRealPath("") + File.separator + PASTA_IMAGENS;
        Files.createDirectories(Paths.get(pastaReal));
        String nomeOriginal = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String extensao = nomeOriginal.contains(".") ? nomeOriginal.substring(nomeOriginal.lastIndexOf(".")) : ".jpg";
        String nomeUnico = "prod_" + System.currentTimeMillis() + extensao;
        filePart.write(pastaReal + File.separator + nomeUnico);
        return nomeUnico;
    }

    private void apagarImagem(HttpServletRequest req, String nomeImagem) {
        try {
            String caminho = req.getServletContext().getRealPath("") + File.separator + PASTA_IMAGENS + File.separator + nomeImagem;
            Files.deleteIfExists(Paths.get(caminho));
        } catch (IOException ignored) {}
    }

    private boolean autenticado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("funcionario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login"); return false;
        }
        return true;
    }
}

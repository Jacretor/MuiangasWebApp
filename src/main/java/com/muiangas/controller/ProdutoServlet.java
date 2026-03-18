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

/**
 * Servlet CRUD completo para produtos com suporte a upload de imagens.
 */
@WebServlet(name = "ProdutoServlet", urlPatterns = "/admin/produtos")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1MB em memória
    maxFileSize       = 5 * 1024 * 1024,  // 5MB por ficheiro
    maxRequestSize    = 10 * 1024 * 1024  // 10MB por pedido
)
public class ProdutoServlet extends HttpServlet {

    private final ProdutoDAO    produtoDAO   = new ProdutoDAO();
    private final CategoriaDAO  categoriaDAO = new CategoriaDAO();

    // Pasta onde as imagens são guardadas (dentro do webapp)
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

            } else if ("eliminar".equals(acao)) {
                // Apagar imagem associada se existir
                Produto p = produtoDAO.buscarPorId(Integer.parseInt(req.getParameter("id")));
                if (p != null && p.getImagem() != null) {
                    apagarImagem(req, p.getImagem());
                }
                produtoDAO.eliminar(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect(req.getContextPath() + "/admin/produtos?msg=eliminado");

            } else {
                req.setAttribute("produtos", produtoDAO.listarTodos());
                req.getRequestDispatcher("/views/admin/produtos.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("erro", "Erro: " + e.getMessage());
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

            // Processar upload de imagem
            Part filePart = req.getPart("imagem");
            if (filePart != null && filePart.getSize() > 0) {
                String nomeImagem = guardarImagem(req, filePart);
                // Se estava a editar, apagar imagem antiga
                if (p.getId() > 0) {
                    Produto antigo = produtoDAO.buscarPorId(p.getId());
                    if (antigo != null && antigo.getImagem() != null) {
                        apagarImagem(req, antigo.getImagem());
                    }
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

    /**
     * Guarda o ficheiro de imagem na pasta do servidor e devolve o nome do ficheiro.
     */
    private String guardarImagem(HttpServletRequest req, Part filePart) throws IOException {
        String pastaReal = req.getServletContext().getRealPath("") + File.separator + PASTA_IMAGENS;
        Files.createDirectories(Paths.get(pastaReal));

        // Gerar nome único para evitar colisões
        String nomeOriginal = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String extensao = nomeOriginal.contains(".")
            ? nomeOriginal.substring(nomeOriginal.lastIndexOf("."))
            : ".jpg";
        String nomeUnico = "prod_" + System.currentTimeMillis() + extensao;

        filePart.write(pastaReal + File.separator + nomeUnico);
        return nomeUnico;
    }

    /**
     * Apaga o ficheiro de imagem do servidor.
     */
    private void apagarImagem(HttpServletRequest req, String nomeImagem) {
        try {
            String caminho = req.getServletContext().getRealPath("") + File.separator + PASTA_IMAGENS + File.separator + nomeImagem;
            Files.deleteIfExists(Paths.get(caminho));
        } catch (IOException ignored) {}
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

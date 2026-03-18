package com.muiangas.controller;

import com.muiangas.dao.MesaDAO;
import com.muiangas.model.Mesa;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "MesaServlet", urlPatterns = "/admin/mesas")
public class MesaServlet extends HttpServlet {

    private final MesaDAO dao = new MesaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!autenticado(req, resp)) return;
        String acao = req.getParameter("acao");

        try {
            if ("nova".equals(acao)) {
                req.setAttribute("mesa", new Mesa());
                req.getRequestDispatcher("/views/admin/mesa-form.jsp").forward(req, resp);

            } else if ("editar".equals(acao)) {
                req.setAttribute("mesa", dao.buscarPorId(Integer.parseInt(req.getParameter("id"))));
                req.getRequestDispatcher("/views/admin/mesa-form.jsp").forward(req, resp);

            } else if ("status".equals(acao)) {
                dao.alterarStatus(Integer.parseInt(req.getParameter("id")), req.getParameter("s"));
                resp.sendRedirect(req.getContextPath() + "/admin/mesas");

            } else if ("eliminar".equals(acao)) {
                // ── NOVA ACÇÃO: eliminar mesa ──
                int id = Integer.parseInt(req.getParameter("id"));
                try {
                    dao.eliminar(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/mesas?sucesso=eliminada");
                } catch (Exception e) {
                    // Pode falhar se mesa tiver pedidos associados
                    req.setAttribute("erro", "Não é possível eliminar esta mesa — tem pedidos associados.");
                    req.setAttribute("mesas", dao.listarTodas());
                    req.getRequestDispatcher("/views/admin/mesas.jsp").forward(req, resp);
                }

            } else {
                String sucesso = req.getParameter("sucesso");
                if ("eliminada".equals(sucesso)) {
                    req.setAttribute("sucesso", "Mesa eliminada com sucesso.");
                }
                req.setAttribute("mesas", dao.listarTodas());
                req.getRequestDispatcher("/views/admin/mesas.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("erro", "Erro: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/mesas.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!autenticado(req, resp)) return;
        req.setCharacterEncoding("UTF-8");

        try {
            Mesa m = new Mesa();
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isBlank()) m.setId(Integer.parseInt(idStr));
            m.setNumero(Integer.parseInt(req.getParameter("numero")));
            m.setCapacidade(Integer.parseInt(req.getParameter("capacidade")));
            m.setStatus(req.getParameter("status") != null ? req.getParameter("status") : "livre");

            if (m.getId() > 0) dao.actualizar(m);
            else               dao.inserir(m);
            resp.sendRedirect(req.getContextPath() + "/admin/mesas");

        } catch (Exception e) {
            req.setAttribute("erro", "Erro: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/mesa-form.jsp").forward(req, resp);
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

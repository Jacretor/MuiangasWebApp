package com.muiangas.controller;

import com.muiangas.dao.ReservaDAO;
import com.muiangas.model.Reserva;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

/**
 * Servlet de reservas: formulário público e gestão admin.
 */
@WebServlet(name = "ReservaServlet", urlPatterns = {"/reserva", "/admin/reservas"})
public class ReservaServlet extends HttpServlet {

    private final ReservaDAO dao = new ReservaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/reserva".equals(path)) {
            req.getRequestDispatcher("/views/public/reserva.jsp").forward(req, resp);
        } else {
            // admin/reservas
            HttpSession s = req.getSession(false);
            if (s == null || s.getAttribute("funcionario") == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            try {
                String acao = req.getParameter("acao");
                if ("confirmar".equals(acao)) {
                    new ReservaDAO().confirmar(Integer.parseInt(req.getParameter("id")));
                } else if ("cancelar".equals(acao)) {
                    new ReservaDAO().cancelar(Integer.parseInt(req.getParameter("id")));
                }
                req.setAttribute("reservas", new ReservaDAO().listarTodas());
            } catch (Exception e) {
                req.setAttribute("erro", "Erro: " + e.getMessage());
            }
            req.getRequestDispatcher("/views/admin/reservas.jsp").forward(req, resp);
        }
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        try {
            Reserva r = new Reserva();
            r.setNomeCliente(req.getParameter("nome"));
            r.setTelefone(req.getParameter("telefone"));
            r.setDataReserva(Date.valueOf(req.getParameter("data")));
            r.setHoraReserva(Time.valueOf(req.getParameter("hora") + ":00"));
            r.setNumPessoas(Integer.parseInt(req.getParameter("pessoas")));
            dao.inserir(r);
            req.setAttribute("sucesso", "Reserva efectuada com sucesso! Entraremos em contacto para confirmar.");
        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao registar a reserva. Verifique os dados.");
        }
        req.getRequestDispatcher("/views/public/reserva.jsp").forward(req, resp);
    }
}

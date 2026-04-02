package com.muiangas.controller;

import com.muiangas.dao.ReservaDAO;
import com.muiangas.model.Cliente;
import com.muiangas.model.Reserva;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

@WebServlet(name = "ReservaServlet", urlPatterns = {"/reserva", "/admin/reservas"})
public class ReservaServlet extends HttpServlet {

    private final ReservaDAO dao = new ReservaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/reserva".equals(path)) {
            // Página pública — qualquer um pode ver, mas só logados podem submeter
            req.getRequestDispatcher("/views/public/reserva.jsp").forward(req, resp);

        } else {
            // Admin
            HttpSession s = req.getSession(false);
            if (s == null || s.getAttribute("funcionario") == null) {
                resp.sendRedirect(req.getContextPath() + "/login"); return;
            }
            try {
                String acao = req.getParameter("acao");
                if ("confirmar".equals(acao)) {
                    dao.confirmar(Integer.parseInt(req.getParameter("id")));
                } else if ("cancelar".equals(acao)) {
                    dao.cancelar(Integer.parseInt(req.getParameter("id")));
                } else if ("naoCompareceu".equals(acao)) {
                    dao.marcarNaoCompareceu(Integer.parseInt(req.getParameter("id")));
                }
                req.setAttribute("reservas", dao.listarTodas());
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

        // ── Verificar se cliente está logado ──────────────────────
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("cliente") == null) {
            resp.sendRedirect(req.getContextPath() + "/cliente/login?redirect=/reserva");
            return;
        }
        Cliente cliente = (Cliente) session.getAttribute("cliente");

        try {
            // Validar data — não pode ser no passado
            String dataStr = req.getParameter("data");
            String horaStr = req.getParameter("hora");
            Date dataReserva = Date.valueOf(dataStr);
            Date hoje = new Date(System.currentTimeMillis());
            if (dataReserva.before(hoje)) {
                req.setAttribute("erro", "A data da reserva não pode ser no passado.");
                req.getRequestDispatcher("/views/public/reserva.jsp").forward(req, resp);
                return;
            }

            Reserva r = new Reserva();
            r.setClienteId(cliente.getId());
            r.setNomeCliente(req.getParameter("nome"));
            r.setTelefone(req.getParameter("telefone"));
            r.setDataReserva(dataReserva);
            r.setHoraReserva(Time.valueOf(horaStr + ":00"));
            r.setNumPessoas(Integer.parseInt(req.getParameter("pessoas")));
            r.setObservacoes(req.getParameter("observacoes"));
            r.setStatus("pendente");

            dao.inserir(r);

            req.setAttribute("sucesso", "Reserva efectuada com sucesso! " +
                "Receberás confirmação via WhatsApp em breve.");
            req.getRequestDispatcher("/views/public/reserva.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao registar a reserva: " + e.getMessage());
            req.getRequestDispatcher("/views/public/reserva.jsp").forward(req, resp);
        }
    }
}

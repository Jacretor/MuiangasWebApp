package com.muiangas.controller;

import com.muiangas.dao.DeliveryDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AdminDeliveryServlet", urlPatterns = "/admin/delivery")
public class AdminDeliveryServlet extends HttpServlet {

    private final DeliveryDAO deliveryDAO = new DeliveryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String filtro = req.getParameter("status");
        if (filtro == null || filtro.isEmpty()) filtro = "todos";
        try {
            req.setAttribute("pedidos",     deliveryDAO.listarPedidos(filtro));
            req.setAttribute("pendentes",   deliveryDAO.contarPendentes());
            req.setAttribute("comProva",    deliveryDAO.contarComComprovativo());
            req.setAttribute("filtroAtual", filtro);
        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao carregar pedidos: " + e.getMessage());
        }
        req.getRequestDispatcher("/views/admin/delivery.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String acao   = req.getParameter("acao");
        int    id     = Integer.parseInt(req.getParameter("id"));
        String status = req.getParameter("status");

        try {
            if ("aprovarPagamento".equals(acao)) {
                deliveryDAO.aprovarPagamento(id);
                // Ao aprovar pagamento, confirmar o pedido automaticamente
                deliveryDAO.actualizarStatus(id, "confirmado");
            } else if ("rejeitarPagamento".equals(acao)) {
                deliveryDAO.rejeitarPagamento(id);
            } else if (status != null && !status.isEmpty()) {
                deliveryDAO.actualizarStatus(id, status);
            }
        } catch (Exception e) {
            req.setAttribute("erro", "Erro: " + e.getMessage());
        }

        String filtro = req.getParameter("filtroAtual");
        if (filtro == null) filtro = "todos";
        resp.sendRedirect(req.getContextPath() + "/admin/delivery?status=" + filtro);
    }
}

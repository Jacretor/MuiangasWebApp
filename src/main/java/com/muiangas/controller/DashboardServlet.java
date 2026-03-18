package com.muiangas.controller;

import com.muiangas.dao.DeliveryDAO;
import com.muiangas.dao.MesaDAO;
import com.muiangas.dao.PedidoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "DashboardServlet", urlPatterns = "/admin/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("funcionario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            PedidoDAO   pedidoDAO   = new PedidoDAO();
            MesaDAO     mesaDAO     = new MesaDAO();
            DeliveryDAO deliveryDAO = new DeliveryDAO();

            // ── Pedidos de mesa ──
            BigDecimal totalVendas   = pedidoDAO.totalVendasHoje();
            int        pedidosAbertos = pedidoDAO.contarAbertos();

            // ── Delivery ──
            BigDecimal totalDelivery    = deliveryDAO.totalVendasHoje();
            int        pedidosDelivery  = deliveryDAO.contarHoje();
            int        deliveryPendentes = deliveryDAO.contarPendentes();
            int        comComprovativo  = deliveryDAO.contarComComprovativo();

            // ── Total geral (mesa + delivery) ──
            BigDecimal totalGeral = totalVendas.add(totalDelivery);

            // ── Mesas ──
            int mesasLivres   = mesaDAO.contarPorStatus("livre");
            int mesasOcupadas = mesaDAO.contarPorStatus("ocupada");

            req.setAttribute("totalVendas",       totalVendas);
            req.setAttribute("totalDelivery",     totalDelivery);
            req.setAttribute("totalGeral",        totalGeral);
            req.setAttribute("pedidosAbertos",    pedidosAbertos);
            req.setAttribute("pedidosDelivery",   pedidosDelivery);
            req.setAttribute("deliveryPendentes", deliveryPendentes);
            req.setAttribute("comComprovativo",   comComprovativo);
            req.setAttribute("mesasLivres",       mesasLivres);
            req.setAttribute("mesasOcupadas",     mesasOcupadas);
            req.setAttribute("pedidosRecentes",   pedidoDAO.listarAbertos());

        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao carregar dados: " + e.getMessage());
        }

        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}

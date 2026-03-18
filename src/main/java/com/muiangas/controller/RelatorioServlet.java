package com.muiangas.controller;

import com.muiangas.dao.DeliveryDAO;
import com.muiangas.dao.PedidoDAO;
import com.muiangas.model.Pedido;
import com.muiangas.model.PedidoDelivery;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "RelatorioServlet", urlPatterns = "/admin/relatorios")
public class RelatorioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("funcionario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String inicio = req.getParameter("inicio");
        String fim    = req.getParameter("fim");
        if (inicio == null || inicio.isBlank()) inicio = LocalDate.now().toString();
        if (fim    == null || fim.isBlank())    fim    = LocalDate.now().toString();

        try {
            // ── Pedidos de mesa ──
            PedidoDAO dao = new PedidoDAO();
            List<Pedido> pedidos = dao.listarPorPeriodo(inicio, fim);
            BigDecimal totalMesa = pedidos.stream()
                .map(Pedido::getTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

            // ── Pedidos de delivery ──
            DeliveryDAO deliveryDAO = new DeliveryDAO();
            List<PedidoDelivery> pedidosDelivery = deliveryDAO.listarPorPeriodo(inicio, fim);
            BigDecimal totalDelivery = pedidosDelivery.stream()
                .map(PedidoDelivery::getTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

            // ── Total geral ──
            BigDecimal totalGeral = totalMesa.add(totalDelivery);

            req.setAttribute("pedidos",          pedidos);
            req.setAttribute("totalMesa",        totalMesa);
            req.setAttribute("pedidosDelivery",  pedidosDelivery);
            req.setAttribute("totalDelivery",    totalDelivery);
            req.setAttribute("totalGeral",       totalGeral);
            req.setAttribute("dataInicio",       inicio);
            req.setAttribute("dataFim",          fim);

        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao gerar relatório: " + e.getMessage());
        }

        req.getRequestDispatcher("/views/admin/relatorio.jsp").forward(req, resp);
    }
}

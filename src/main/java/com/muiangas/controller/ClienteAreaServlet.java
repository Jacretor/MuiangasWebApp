package com.muiangas.controller;

import com.muiangas.dao.ClienteDAO;
import com.muiangas.dao.DeliveryDAO;
import com.muiangas.dao.ReservaDAO;
import com.muiangas.dao.ProdutoDAO;
import com.muiangas.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ClienteAreaServlet", urlPatterns = "/cliente/area")
public class ClienteAreaServlet extends HttpServlet {

    private final ClienteDAO  clienteDAO  = new ClienteDAO();
    private final DeliveryDAO deliveryDAO = new DeliveryDAO();
    private final ReservaDAO  reservaDAO  = new ReservaDAO();
    private final ProdutoDAO  produtoDAO  = new ProdutoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Cliente cliente = clienteLogado(req, resp);
        if (cliente == null) return;

        String aba = req.getParameter("aba");
        if (aba == null) aba = "inicio";

        try {
            req.setAttribute("aba", aba);
            req.setAttribute("cliente", cliente);

            switch (aba) {
                case "historico":
                    req.setAttribute("pedidos", deliveryDAO.listarPorCliente(cliente.getId()));
                    break;

                case "reservas":
                    req.setAttribute("reservas", reservaDAO.listarPorCliente(cliente.getId()));
                    break;

                case "enderecos":
                    req.setAttribute("enderecos", clienteDAO.listarEnderecos(cliente.getId()));
                    req.setAttribute("zonas",     deliveryDAO.listarZonasAtivas());
                    break;

                case "favoritos":
                    List<Integer> favIds = clienteDAO.listarFavoritosIds(cliente.getId());
                    req.setAttribute("favIds",    favIds);
                    req.setAttribute("favoritos", produtoDAO.listarPorIds(favIds));
                    break;

                case "avaliacoes":
                    req.setAttribute("avaliacoes", clienteDAO.listarAvaliacoes(cliente.getId()));
                    req.setAttribute("pedidos",    deliveryDAO.listarPorCliente(cliente.getId()));
                    break;

                default: // inicio
                    req.setAttribute("pedidos",   deliveryDAO.listarPorCliente(cliente.getId()));
                    req.setAttribute("reservas",  reservaDAO.listarPorCliente(cliente.getId()));
                    req.setAttribute("favCount",  clienteDAO.listarFavoritosIds(cliente.getId()).size());
                    req.setAttribute("endCount",  clienteDAO.listarEnderecos(cliente.getId()).size());
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao carregar dados: " + e.getMessage());
        }

        req.getRequestDispatcher("/views/public/cliente-area.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Cliente cliente = clienteLogado(req, resp);
        if (cliente == null) return;

        String acao = req.getParameter("acao");

        try {
            switch (acao != null ? acao : "") {

                case "adicionarEndereco": {
                    EnderecoCliente e = new EnderecoCliente();
                    e.setClienteId(cliente.getId());
                    e.setNome(req.getParameter("nomeEnd"));
                    e.setMorada(req.getParameter("morada"));
                    String zonaStr = req.getParameter("zonaId");
                    e.setZonaId(zonaStr != null && !zonaStr.isBlank() ? Integer.parseInt(zonaStr) : 0);
                    e.setPredefinido("on".equals(req.getParameter("predefinido")));
                    clienteDAO.inserirEndereco(e);
                    resp.sendRedirect(req.getContextPath() + "/cliente/area?aba=enderecos&sucesso=1");
                    return;
                }

                case "eliminarEndereco": {
                    clienteDAO.eliminarEndereco(
                        Integer.parseInt(req.getParameter("id")), cliente.getId());
                    resp.sendRedirect(req.getContextPath() + "/cliente/area?aba=enderecos");
                    return;
                }

                case "toggleFavorito": {
                    clienteDAO.toggleFavorito(
                        cliente.getId(), Integer.parseInt(req.getParameter("produtoId")));
                    // resposta JSON simples para AJAX
                    resp.setContentType("application/json");
                    resp.getWriter().write("{\"ok\":true}");
                    return;
                }

                case "avaliar": {
                    int pedidoId = Integer.parseInt(req.getParameter("pedidoId"));
                    if (!clienteDAO.jaAvaliou(cliente.getId(), pedidoId)) {
                        Avaliacao a = new Avaliacao();
                        a.setClienteId(cliente.getId());
                        a.setPedidoId(pedidoId);
                        a.setEstrelas(Integer.parseInt(req.getParameter("estrelas")));
                        a.setComentario(req.getParameter("comentario"));
                        clienteDAO.inserirAvaliacao(a);
                    }
                    resp.sendRedirect(req.getContextPath() + "/cliente/area?aba=avaliacoes&sucesso=1");
                    return;
                }
            }
        } catch (Exception e) {
            req.setAttribute("erro", "Erro: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/cliente/area");
    }

    private Cliente clienteLogado(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("cliente") == null) {
            resp.sendRedirect(req.getContextPath() + "/cliente/login?redirect=/cliente/area");
            return null;
        }
        return (Cliente) session.getAttribute("cliente");
    }
}

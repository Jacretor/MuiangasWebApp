<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Dashboard — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="sidebar.jspf" %>

<div class="page-header">
    <div>
        <h1 class="page-title">Dashboard</h1>
        <p class="page-subtitle">Resumo do dia — <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy"/></p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/pedidos?acao=novo" class="btn btn-gold">+ Novo Pedido</a>
</div>

<c:if test="${not empty erro}">
    <div class="alert alert-danger"><c:out value="${erro}"/></div>
</c:if>

<c:if test="${comComprovativo > 0}">
    <div class="alert" style="background:rgba(100,160,220,0.1);border:1px solid rgba(100,160,220,0.3);color:#64A0DC;border-radius:8px;padding:0.8rem 1.2rem;margin-bottom:1.5rem;font-size:0.82rem;">
        📎 <strong>${comComprovativo}</strong> comprovativo(s) de pagamento delivery por verificar —
        <a href="${pageContext.request.contextPath}/admin/delivery?status=pendente" style="color:#64A0DC;font-weight:700;">Ver agora →</a>
    </div>
</c:if>

<!-- STAT CARDS — VENDAS -->
<p style="font-size:0.6rem;letter-spacing:3px;text-transform:uppercase;color:#3A3028;margin-bottom:0.8rem;">Vendas de Hoje</p>
<div class="grid-4 mb-4">
    <div class="stat-card" style="border-left:3px solid #C8A951;">
        <div class="stat-value"><fmt:formatNumber value="${totalGeral}" pattern="#,##0.00"/></div>
        <div class="stat-label">Total Geral (MZN)</div>
    </div>
    <div class="stat-card">
        <div class="stat-value"><fmt:formatNumber value="${totalVendas}" pattern="#,##0.00"/></div>
        <div class="stat-label">Vendas Mesa (MZN)</div>
    </div>
    <div class="stat-card">
        <div class="stat-value"><fmt:formatNumber value="${totalDelivery}" pattern="#,##0.00"/></div>
        <div class="stat-label">Vendas Delivery (MZN)</div>
    </div>
    <div class="stat-card">
        <div class="stat-value">${pedidosDelivery}</div>
        <div class="stat-label">Pedidos Delivery Hoje</div>
    </div>
</div>

<!-- STAT CARDS — ESTADO -->
<p style="font-size:0.6rem;letter-spacing:3px;text-transform:uppercase;color:#3A3028;margin-bottom:0.8rem;">Estado Actual</p>
<div class="grid-4 mb-4">
    <div class="stat-card">
        <div class="stat-value">${pedidosAbertos}</div>
        <div class="stat-label">Pedidos Mesa Abertos</div>
    </div>
    <div class="stat-card" style="<c:if test='${deliveryPendentes > 0}'>border-left:3px solid #C8A951;</c:if>">
        <div class="stat-value">${deliveryPendentes}</div>
        <div class="stat-label">Delivery Pendentes</div>
    </div>
    <div class="stat-card">
        <div class="stat-value">${mesasLivres}</div>
        <div class="stat-label">Mesas Livres</div>
    </div>
    <div class="stat-card">
        <div class="stat-value">${mesasOcupadas}</div>
        <div class="stat-label">Mesas Ocupadas</div>
    </div>
</div>

<!-- PEDIDOS RECENTES -->
<div class="card">
    <div class="card-title">Pedidos de Mesa Abertos</div>
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>#</th><th>Mesa</th><th>Cliente</th><th>Funcionário</th>
                    <th>Data/Hora</th><th>Total (MZN)</th><th>Acções</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${pedidosRecentes}">
                <tr>
                    <td>#<c:out value="${p.id}"/></td>
                    <td>Mesa <c:out value="${p.mesaNumero}"/></td>
                    <td><c:out value="${p.clienteNome}"/></td>
                    <td><c:out value="${p.funcionarioNome}"/></td>
                    <td><fmt:formatDate value="${p.dataHora}" pattern="dd/MM HH:mm"/></td>
                    <td class="text-gold"><fmt:formatNumber value="${p.total}" pattern="#,##0.00"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/pedidos?acao=ver&id=${p.id}"
                           class="btn btn-outline btn-sm">Ver</a>
                    </td>
                </tr>
                </c:forEach>
                <c:if test="${empty pedidosRecentes}">
                <tr><td colspan="7" class="text-center text-muted" style="padding:2rem;">Sem pedidos abertos.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

</div>
</div>
</body>
</html>

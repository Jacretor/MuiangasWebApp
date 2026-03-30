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

<div class="main-content">
<div class="page-header">
    <div>
        <h1 class="page-title">Dashboard</h1>
        <p class="page-subtitle">Resumo do dia — <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd 'de' MMMM 'de' yyyy"/></p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/pedidos?acao=novo" class="btn btn-gold">+ Novo Pedido</a>
</div>

<c:if test="${not empty erro}">
    <div class="alert alert-danger"><c:out value="${erro}"/></div>
</c:if>

<c:if test="${comComprovativo > 0}">
    <div class="alert" style="background:rgba(100,160,220,0.08);border:1px solid rgba(100,160,220,0.25);color:#6090C8;border-radius:8px;padding:0.8rem 1.2rem;margin-bottom:1.5rem;font-size:0.82rem;display:flex;align-items:center;gap:0.8rem;">
        <svg viewBox="0 0 24 24" width="16" height="16" style="stroke:#6090C8;fill:none;stroke-width:2;stroke-linecap:round;flex-shrink:0;"><path d="M21.44 11.05l-9.19 9.19a6 6 0 01-8.49-8.49l9.19-9.19a4 4 0 015.66 5.66l-9.2 9.19a2 2 0 01-2.83-2.83l8.49-8.48"/></svg>
        <span><strong>${comComprovativo}</strong> comprovativo(s) por verificar —
        <a href="${pageContext.request.contextPath}/admin/delivery?status=pendente" style="color:#6090C8;font-weight:700;">Ver agora →</a></span>
    </div>
</c:if>

<!-- VENDAS HOJE -->
<p style="font-size:0.58rem;letter-spacing:4px;text-transform:uppercase;color:#3A3028;margin-bottom:0.8rem;">Vendas de Hoje</p>
<div class="grid-4 mb-4">
    <div class="stat-card" style="border-top-color:#C8A951;">
        <div class="stat-icon">
            <svg viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
        </div>
        <div class="stat-value"><fmt:formatNumber value="${totalGeral}" pattern="#,##0"/></div>
        <div class="stat-label">Total Geral (MZN)</div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">
            <svg viewBox="0 0 24 24"><path d="M3 11l19-9-9 19-2-8-8-2z"/></svg>
        </div>
        <div class="stat-value"><fmt:formatNumber value="${totalVendas}" pattern="#,##0"/></div>
        <div class="stat-label">Vendas Mesa (MZN)</div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">
            <svg viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
        </div>
        <div class="stat-value"><fmt:formatNumber value="${totalDelivery}" pattern="#,##0"/></div>
        <div class="stat-label">Vendas Delivery (MZN)</div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">
            <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
        </div>
        <div class="stat-value">${pedidosDelivery}</div>
        <div class="stat-label">Pedidos Delivery Hoje</div>
    </div>
</div>

<!-- ESTADO ACTUAL -->
<p style="font-size:0.58rem;letter-spacing:4px;text-transform:uppercase;color:#3A3028;margin-bottom:0.8rem;">Estado Actual</p>
<div class="grid-4 mb-4">
    <div class="stat-card">
        <div class="stat-icon">
            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
        </div>
        <div class="stat-value">${pedidosAbertos}</div>
        <div class="stat-label">Pedidos Mesa Abertos</div>
    </div>
    <div class="stat-card ${deliveryPendentes > 0 ? 'style=\"border-top-color:#C8A951;\"' : ''}">
        <div class="stat-icon">
            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
        </div>
        <div class="stat-value">${deliveryPendentes}</div>
        <div class="stat-label">Delivery Pendentes</div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">
            <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
        </div>
        <div class="stat-value">${mesasLivres}</div>
        <div class="stat-label">Mesas Livres</div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">
            <svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/></svg>
        </div>
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

</div><%-- main-content --%>
</body>
</html>

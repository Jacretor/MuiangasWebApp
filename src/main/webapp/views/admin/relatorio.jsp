<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Relatório de Vendas — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .sec-rel { font-size:0.6rem; letter-spacing:3px; text-transform:uppercase; color:#3A3028; margin:1.5rem 0 0.8rem; display:flex; align-items:center; gap:0.8rem; }
        .sec-rel::before { content:''; width:24px; height:1px; background:#3A3028; }
        .badge-metodo { display:inline-block; padding:0.2rem 0.6rem; border-radius:20px; font-size:0.62rem; font-weight:700; letter-spacing:1px; text-transform:uppercase; }
        .bm-mpesa    { background:rgba(200,169,81,0.15); color:#C8A951; }
        .bm-emola    { background:rgba(224,80,80,0.15);  color:#E07070; }
        .bm-dinheiro { background:rgba(120,200,120,0.15);color:#78C878; }
        .bm-pago     { background:rgba(80,160,80,0.15);  color:#50A050; }
        .bm-cancelado{ background:rgba(220,80,60,0.15);  color:#DC503C; }
        .bm-aberto   { background:rgba(200,169,81,0.15); color:#C8A951; }
        .total-resumo { display:grid; grid-template-columns:repeat(3,1fr); gap:1rem; margin-bottom:1.5rem; }
        .tr-card { background:#161210; border:1px solid #1E1814; border-radius:8px; padding:1.2rem 1.5rem; text-align:center; }
        .tr-val  { font-size:1.3rem; font-weight:900; color:#C8A951; }
        .tr-label{ font-size:0.6rem; letter-spacing:2px; text-transform:uppercase; color:#3A3028; margin-top:0.3rem; }
        .tr-card.destaque { border-color:#C8A951; }
    </style>
</head>
<body>

<%@ include file="sidebar.jspf" %>

<div class="page-header">
    <h1 class="page-title">Relatório de Vendas</h1>
</div>

<c:if test="${not empty erro}">
    <div class="alert alert-danger"><c:out value="${erro}"/></div>
</c:if>

<!-- FILTRO -->
<div class="card mb-3" style="max-width:500px;">
    <div class="card-title">Filtrar por Período</div>
    <form method="get" action="${pageContext.request.contextPath}/admin/relatorios">
        <div class="grid-2">
            <div class="form-group">
                <label class="form-label">De</label>
                <input type="date" name="inicio" class="form-control" value="${dataInicio}">
            </div>
            <div class="form-group">
                <label class="form-label">Até</label>
                <input type="date" name="fim" class="form-control" value="${dataFim}">
            </div>
        </div>
        <button type="submit" class="btn btn-gold">Filtrar</button>
    </form>
</div>

<!-- RESUMO GERAL -->
<div class="total-resumo">
    <div class="tr-card destaque">
        <div class="tr-val"><fmt:formatNumber value="${totalGeral}" pattern="#,##0.00"/></div>
        <div class="tr-label">Total Geral (MZN)</div>
    </div>
    <div class="tr-card">
        <div class="tr-val"><fmt:formatNumber value="${totalMesa}" pattern="#,##0.00"/></div>
        <div class="tr-label">Vendas Mesa (MZN)</div>
    </div>
    <div class="tr-card">
        <div class="tr-val"><fmt:formatNumber value="${totalDelivery}" pattern="#,##0.00"/></div>
        <div class="tr-label">Vendas Delivery (MZN)</div>
    </div>
</div>

<!-- ══ PEDIDOS DE MESA ══ -->
<div class="sec-rel">🪑 Pedidos de Mesa — ${pedidos.size()} registos</div>
<div class="card mb-3">
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>#</th><th>Data/Hora</th><th>Mesa</th><th>Cliente</th>
                    <th>Funcionário</th><th>Status</th><th>Total (MZN)</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${pedidos}">
                <tr>
                    <td>#${p.id}</td>
                    <td><fmt:formatDate value="${p.dataHora}" pattern="dd/MM/yyyy HH:mm"/></td>
                    <td>Mesa ${p.mesaNumero}</td>
                    <td><c:out value="${p.clienteNome}"/></td>
                    <td><c:out value="${p.funcionarioNome}"/></td>
                    <td>
                        <span class="badge-metodo
                            <c:choose>
                                <c:when test="${p.status == 'pago'}">bm-pago</c:when>
                                <c:when test="${p.status == 'cancelado'}">bm-cancelado</c:when>
                                <c:otherwise>bm-aberto</c:otherwise>
                            </c:choose>">
                            <c:out value="${p.status}"/>
                        </span>
                    </td>
                    <td class="text-gold"><fmt:formatNumber value="${p.total}" pattern="#,##0.00"/></td>
                </tr>
                </c:forEach>
                <c:if test="${empty pedidos}">
                <tr><td colspan="7" class="text-center text-muted" style="padding:2rem;">Sem registos no período.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<!-- ══ PEDIDOS DE DELIVERY ══ -->
<div class="sec-rel">🛵 Pedidos de Delivery — ${pedidosDelivery.size()} registos</div>
<div class="card mb-3">
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>#</th><th>Data/Hora</th><th>Cliente</th><th>Telefone</th>
                    <th>Zona</th><th>Pagamento</th><th>Status</th><th>Total (MZN)</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="d" items="${pedidosDelivery}">
                <tr>
                    <td>#${d.id}</td>
                    <td><fmt:formatDate value="${d.dataHora}" pattern="dd/MM/yyyy HH:mm"/></td>
                    <td><c:out value="${d.clienteNome}"/></td>
                    <td><c:out value="${d.clienteTelefone}"/></td>
                    <td><c:out value="${d.zonaNome}"/></td>
                    <td>
                        <span class="badge-metodo bm-${d.metodoPagamento}">
                            <c:choose>
                                <c:when test="${d.metodoPagamento == 'mpesa'}">📱 M-Pesa</c:when>
                                <c:when test="${d.metodoPagamento == 'emola'}">📲 eMola</c:when>
                                <c:otherwise>💵 Dinheiro</c:otherwise>
                            </c:choose>
                        </span>
                    </td>
                    <td>
                        <span class="badge-metodo
                            <c:choose>
                                <c:when test="${d.status == 'entregue'}">bm-pago</c:when>
                                <c:when test="${d.status == 'cancelado'}">bm-cancelado</c:when>
                                <c:otherwise>bm-aberto</c:otherwise>
                            </c:choose>">
                            <c:out value="${d.status}"/>
                        </span>
                    </td>
                    <td class="text-gold"><fmt:formatNumber value="${d.total}" pattern="#,##0.00"/></td>
                </tr>
                </c:forEach>
                <c:if test="${empty pedidosDelivery}">
                <tr><td colspan="8" class="text-center text-muted" style="padding:2rem;">Sem registos no período.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

</div>
</div>
</body>
</html>

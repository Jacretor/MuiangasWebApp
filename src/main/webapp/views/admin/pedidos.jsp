<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Pedidos — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="sidebar.jspf" %>

<div class="page-header">
    <div>
        <h1 class="page-title">Pedidos Abertos</h1>
    </div>
    <a href="${pageContext.request.contextPath}/admin/pedidos?acao=novo" class="btn btn-gold">+ Novo Pedido</a>
</div>

<c:if test="${param.msg == 'pago'}"><div class="alert alert-success">Pedido fechado e mesa libertada!</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger"><c:out value="${erro}"/></div></c:if>

<div class="card">
    <div class="table-wrapper">
        <table>
            <thead>
                <tr><th>#</th><th>Mesa</th><th>Cliente</th><th>Funcionário</th><th>Data/Hora</th><th>Total</th><th>Status</th><th>Acções</th></tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${pedidos}">
                <tr>
                    <td>#${p.id}</td>
                    <td>Mesa ${p.mesaNumero}</td>
                    <td><c:out value="${p.clienteNome}"/></td>
                    <td><c:out value="${p.funcionarioNome}"/></td>
                    <td><fmt:formatDate value="${p.dataHora}" pattern="dd/MM HH:mm"/></td>
                    <td class="text-gold"><fmt:formatNumber value="${p.total}" pattern="#,##0.00"/> MZN</td>
                    <td><span class="badge badge-warning"><c:out value="${p.status}"/></span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/pedidos?acao=ver&id=${p.id}" class="btn btn-outline btn-sm">Detalhes</a>
                    </td>
                </tr>
                </c:forEach>
                <c:if test="${empty pedidos}">
                <tr><td colspan="8" class="text-center text-muted" style="padding:2rem;">Sem pedidos abertos.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

</div></div>
</body>
</html>

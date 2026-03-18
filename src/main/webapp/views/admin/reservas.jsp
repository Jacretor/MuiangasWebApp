<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt"><head><meta charset="UTF-8"><title>Reservas — Muianga's</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<%@ include file="sidebar.jspf" %>
<div class="page-header"><h1 class="page-title">Reservas</h1></div>
<c:if test="${not empty erro}"><div class="alert alert-danger"><c:out value="${erro}"/></div></c:if>
<div class="card">
<div class="table-wrapper">
<table>
    <thead><tr><th>Cliente</th><th>Telefone</th><th>Data</th><th>Hora</th><th>Pessoas</th><th>Status</th><th>Acções</th></tr></thead>
    <tbody>
        <c:forEach var="r" items="${reservas}">
        <tr>
            <td><c:out value="${r.nomeCliente}"/></td>
            <td><c:out value="${r.telefone}"/></td>
            <td><fmt:formatDate value="${r.dataReserva}" pattern="dd/MM/yyyy"/></td>
            <td><fmt:formatDate value="${r.horaReserva}" pattern="HH:mm"/></td>
            <td>${r.numPessoas}</td>
            <td>
                <span class="badge ${r.status == 'confirmada' ? 'badge-success' : r.status == 'cancelada' ? 'badge-danger' : 'badge-warning'}">
                    <c:out value="${r.status}"/>
                </span>
            </td>
            <td>
                <c:if test="${r.status == 'pendente'}">
                <a href="${pageContext.request.contextPath}/admin/reservas?acao=confirmar&id=${r.id}" class="btn btn-success btn-sm">Confirmar</a>
                <a href="${pageContext.request.contextPath}/admin/reservas?acao=cancelar&id=${r.id}" class="btn btn-danger btn-sm">Cancelar</a>
                </c:if>
            </td>
        </tr>
        </c:forEach>
        <c:if test="${empty reservas}">
        <tr><td colspan="7" class="text-center text-muted" style="padding:2rem;">Sem reservas registadas.</td></tr>
        </c:if>
    </tbody>
</table>
</div></div>
</div></div>
</body></html>

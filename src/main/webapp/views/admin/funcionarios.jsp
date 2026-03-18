<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt"><head><meta charset="UTF-8"><title>Funcionários — Muianga's</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<%@ include file="sidebar.jspf" %>
<div class="page-header">
    <h1 class="page-title">Funcionários</h1>
    <a href="${pageContext.request.contextPath}/admin/funcionarios?acao=novo" class="btn btn-gold">+ Novo</a>
</div>
<c:if test="${not empty erro}"><div class="alert alert-danger"><c:out value="${erro}"/></div></c:if>
<div class="card">
<div class="table-wrapper">
<table>
    <thead><tr><th>Nome</th><th>E-mail</th><th>Cargo</th><th>Acções</th></tr></thead>
    <tbody>
        <c:forEach var="f" items="${funcionarios}">
        <tr>
            <td><c:out value="${f.nome}"/></td>
            <td><c:out value="${f.email}"/></td>
            <td><span class="badge ${f.admin ? 'badge-gold' : 'badge-muted'}"><c:out value="${f.cargo}"/></span></td>
            <td>
                <a href="${pageContext.request.contextPath}/admin/funcionarios?acao=editar&id=${f.id}" class="btn btn-outline btn-sm">Editar</a>
            </td>
        </tr>
        </c:forEach>
    </tbody>
</table>
</div></div>
</div></div>
</body></html>

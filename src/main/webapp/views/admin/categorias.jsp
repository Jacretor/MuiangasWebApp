<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt"><head><meta charset="UTF-8"><title>Categorias — Muianga's</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body>
<%@ include file="sidebar.jspf" %>
<div class="page-header">
    <h1 class="page-title">Categorias</h1>
    <a href="${pageContext.request.contextPath}/admin/categorias?acao=nova" class="btn btn-gold">+ Nova Categoria</a>
</div>
<c:if test="${not empty erro}"><div class="alert alert-danger"><c:out value="${erro}"/></div></c:if>
<div class="card">
<div class="table-wrapper">
<table>
    <thead><tr><th>Nome</th><th>Descrição</th><th>Acções</th></tr></thead>
    <tbody>
        <c:forEach var="c" items="${categorias}">
        <tr>
            <td><strong><c:out value="${c.nome}"/></strong></td>
            <td class="text-muted"><c:out value="${c.descricao}"/></td>
            <td>
                <a href="${pageContext.request.contextPath}/admin/categorias?acao=editar&id=${c.id}" class="btn btn-outline btn-sm">Editar</a>
                <a href="${pageContext.request.contextPath}/admin/categorias?acao=eliminar&id=${c.id}"
                   class="btn btn-danger btn-sm" onclick="return confirm('Eliminar?')">Eliminar</a>
            </td>
        </tr>
        </c:forEach>
    </tbody>
</table>
</div></div>
</div></div>
</body></html>

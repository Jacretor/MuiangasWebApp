<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Produtos — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="sidebar.jspf" %>

<div class="page-header">
    <div>
        <h1 class="page-title">Produtos</h1>
        <p class="page-subtitle">Gestão do catálogo de produtos</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/produtos?acao=novo" class="btn btn-gold">+ Novo Produto</a>
</div>

<c:if test="${param.msg == 'criado'}"><div class="alert alert-success">Produto criado com sucesso!</div></c:if>
<c:if test="${param.msg == 'actualizado'}"><div class="alert alert-success">Produto actualizado!</div></c:if>
<c:if test="${param.msg == 'eliminado'}"><div class="alert alert-warning">Produto eliminado.</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger"><c:out value="${erro}"/></div></c:if>

<div class="card">
    <div class="table-wrapper">
        <table>
            <thead>
                <tr><th>Nome</th><th>Categoria</th><th>Preço (MZN)</th><th>Disponível</th><th>Acções</th></tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${produtos}">
                <tr>
                    <td><strong><c:out value="${p.nome}"/></strong></td>
                    <td><c:out value="${p.categoriaNome}"/></td>
                    <td class="text-gold"><fmt:formatNumber value="${p.preco}" pattern="#,##0.00"/></td>
                    <td>
                        <span class="badge ${p.disponivel ? 'badge-success' : 'badge-danger'}">
                            ${p.disponivel ? 'Sim' : 'Não'}
                        </span>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/produtos?acao=editar&id=${p.id}" class="btn btn-outline btn-sm">Editar</a>
                        <a href="${pageContext.request.contextPath}/admin/produtos?acao=eliminar&id=${p.id}"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Eliminar produto?')">Eliminar</a>
                    </td>
                </tr>
                </c:forEach>
                <c:if test="${empty produtos}">
                <tr><td colspan="5" class="text-center text-muted" style="padding:2rem;">Sem produtos. Adicione um acima.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

</div></div>
</body>
</html>

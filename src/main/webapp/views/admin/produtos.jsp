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

<div class="main-content">
<div class="page-header">
    <div>
        <h1 class="page-title">Produtos</h1>
        <p class="page-subtitle">Gestão do catálogo de produtos</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/produtos?acao=novo" class="btn btn-gold">+ Novo Produto</a>
</div>

<c:if test="${param.msg == 'criado'}">     <div class="alert alert-success">Produto criado com sucesso!</div></c:if>
<c:if test="${param.msg == 'actualizado'}"><div class="alert alert-success">Produto actualizado!</div></c:if>
<c:if test="${param.msg == 'eliminado'}">  <div class="alert alert-warning">Produto eliminado.</div></c:if>
<c:if test="${param.msg == 'desactivado'}"><div class="alert alert-warning">Produto desactivado — não aparece no menu.</div></c:if>
<c:if test="${param.msg == 'activado'}">  <div class="alert alert-success">Produto activado — já aparece no menu.</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger"><c:out value="${erro}"/></div></c:if>

<div class="card">
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>Nome</th>
                    <th>Categoria</th>
                    <th>Preço (MZN)</th>
                    <th>Disponível</th>
                    <th>Acções</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${produtos}">
                <tr>
                    <td>
                        <strong style="${!p.disponivel ? 'opacity:0.5;' : ''}">
                            <c:out value="${p.nome}"/>
                        </strong>
                    </td>
                    <td><c:out value="${p.categoriaNome}"/></td>
                    <td class="text-gold"><fmt:formatNumber value="${p.preco}" pattern="#,##0.00"/></td>
                    <td>
                        <span class="badge ${p.disponivel ? 'badge-success' : 'badge-danger'}">
                            ${p.disponivel ? 'Disponível' : 'Indisponível'}
                        </span>
                    </td>
                    <td style="display:flex;gap:0.4rem;flex-wrap:wrap;">
                        <a href="${pageContext.request.contextPath}/admin/produtos?acao=editar&id=${p.id}"
                           class="btn btn-outline btn-sm">Editar</a>
                        <c:choose>
                            <c:when test="${p.disponivel}">
                                <a href="${pageContext.request.contextPath}/admin/produtos?acao=desactivar&id=${p.id}"
                                   class="btn btn-sm"
                                   style="border:1px solid rgba(200,169,81,0.3);color:#C8A951;background:transparent;"
                                   onclick="return confirm('Desactivar este produto? Deixará de aparecer no menu.')">
                                   Desactivar
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/admin/produtos?acao=activar&id=${p.id}"
                                   class="btn btn-outline btn-sm">
                                   Activar
                                </a>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/admin/produtos?acao=eliminar&id=${p.id}"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Eliminar produto permanentemente?')">Eliminar</a>
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

</div><%-- main-content --%>
</body>
</html>

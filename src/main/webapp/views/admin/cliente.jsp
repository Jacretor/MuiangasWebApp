<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Gestão de Clientes — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="sidebar.jspf" %>

<div class="main-content">
<div class="page-header">
    <div>
        <h1 class="page-title">Gestão de Clientes</h1>
        <p class="page-subtitle">Clientes registados no sistema</p>
    </div>
</div>

<c:if test="${not empty erro}">
    <div class="alert alert-danger"><c:out value="${erro}"/></div>
</c:if>
<c:if test="${not empty param.msg}">
    <div class="alert alert-success">
        <c:choose>
            <c:when test="${param.msg == 'activado'}">Cliente activado com sucesso.</c:when>
            <c:when test="${param.msg == 'desactivado'}">Cliente desactivado com sucesso.</c:when>
        </c:choose>
    </div>
</c:if>

<div class="card">
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Nome</th>
                    <th>E-mail</th>
                    <th>Telefone</th>
                    <th>Registo</th>
                    <th>Estado</th>
                    <th>Acções</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="c" items="${clientes}">
                <tr>
                    <td>#${c.id}</td>
                    <td><c:out value="${c.nome}"/></td>
                    <td><c:out value="${c.email}"/></td>
                    <td><c:out value="${c.telefone}"/></td>
                    <td>
                        <c:if test="${not empty c.dataRegisto}">
                            <fmt:formatDate value="${c.dataRegisto}" pattern="dd/MM/yyyy"/>
                        </c:if>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${c.ativo}">
                                <span class="badge badge-success">Activo</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-danger">Inactivo</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${c.ativo}">
                                <a href="${pageContext.request.contextPath}/admin/cliente?acao=desactivar&id=${c.id}"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Desactivar este cliente?')">Desactivar</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/admin/cliente?acao=activar&id=${c.id}"
                                   class="btn btn-outline btn-sm">Activar</a>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                </c:forEach>
                <c:if test="${empty clientes}">
                <tr><td colspan="7" class="text-center text-muted" style="padding:2rem;">Nenhum cliente registado.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
</div>
</body>
</html>

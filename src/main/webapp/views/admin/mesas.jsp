<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Mesas — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .mesas-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1.2rem;
        }
        .mesa-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1.4rem;
            position: relative;
            overflow: hidden;
            transition: all 0.2s;
        }
        .mesa-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
        }
        .mesa-card.livre::before    { background: #5A8A5A; }
        .mesa-card.ocupada::before  { background: #8A3A2A; }
        .mesa-card.reservada::before{ background: #C8A951; }
        .mesa-card:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(0,0,0,0.4); }

        .mesa-num {
            font-size: 2rem; font-weight: 900;
            color: var(--text-primary); line-height: 1;
        }
        .mesa-cap {
            font-size: 0.65rem; color: var(--text-faint);
            letter-spacing: 2px; text-transform: uppercase;
            margin-top: 0.3rem; margin-bottom: 1rem;
        }
        /* Badge estado */
        .mesa-badge {
            display: inline-flex; align-items: center; gap: 0.35rem;
            padding: 0.25rem 0.8rem; border-radius: 20px;
            font-size: 0.6rem; font-weight: 700;
            letter-spacing: 1.5px; text-transform: uppercase;
            margin-bottom: 1rem;
        }
        .mesa-badge.livre    { background: rgba(90,138,90,0.15);  color: #70B070; border: 1px solid rgba(90,138,90,0.3); }
        .mesa-badge.ocupada  { background: rgba(138,58,42,0.15);  color: #D06050; border: 1px solid rgba(138,58,42,0.3); }
        .mesa-badge.reservada{ background: rgba(200,169,81,0.12); color: #C8A951; border: 1px solid rgba(200,169,81,0.3); }
        .mesa-badge-dot {
            width: 6px; height: 6px; border-radius: 50%;
        }
        .livre    .mesa-badge-dot { background: #70B070; }
        .ocupada  .mesa-badge-dot { background: #D06050; }
        .reservada.mesa-badge-dot { background: #C8A951; }

        /* Botões de estado rápido */
        .estado-btns {
            display: grid; grid-template-columns: 1fr 1fr 1fr;
            gap: 0.3rem; margin-bottom: 0.8rem;
        }
        .estado-btn {
            padding: 0.35rem 0.2rem;
            border-radius: 6px; border: 1px solid transparent;
            font-family: 'Montserrat', sans-serif;
            font-size: 0.55rem; font-weight: 700;
            letter-spacing: 0.5px; text-transform: uppercase;
            cursor: pointer; transition: all 0.2s;
            text-align: center; text-decoration: none;
            display: block;
        }
        .estado-btn.livre-btn {
            background: rgba(90,138,90,0.1); color: #70B070;
            border-color: rgba(90,138,90,0.25);
        }
        .estado-btn.livre-btn:hover,
        .estado-btn.livre-btn.activo {
            background: rgba(90,138,90,0.3); border-color: #70B070;
        }
        .estado-btn.ocupada-btn {
            background: rgba(138,58,42,0.1); color: #D06050;
            border-color: rgba(138,58,42,0.25);
        }
        .estado-btn.ocupada-btn:hover,
        .estado-btn.ocupada-btn.activo {
            background: rgba(138,58,42,0.3); border-color: #D06050;
        }
        .estado-btn.reservada-btn {
            background: rgba(200,169,81,0.08); color: #C8A951;
            border-color: rgba(200,169,81,0.2);
        }
        .estado-btn.reservada-btn:hover,
        .estado-btn.reservada-btn.activo {
            background: rgba(200,169,81,0.2); border-color: #C8A951;
        }

        /* Acções */
        .mesa-acoes {
            display: flex; gap: 0.4rem; padding-top: 0.8rem;
            border-top: 1px solid var(--border);
        }

        /* Legenda */
        .legenda {
            display: flex; gap: 1.5rem; flex-wrap: wrap;
            margin-bottom: 1.5rem; align-items: center;
        }
        .legenda-item {
            display: flex; align-items: center; gap: 0.5rem;
            font-size: 0.65rem; color: var(--text-muted);
            letter-spacing: 1px; text-transform: uppercase;
        }
        .legenda-dot {
            width: 10px; height: 10px; border-radius: 3px;
        }
        .legenda-dot.livre    { background: #5A8A5A; }
        .legenda-dot.ocupada  { background: #8A3A2A; }
        .legenda-dot.reservada{ background: #C8A951; }

        /* Stats rápidas */
        .mesa-stats {
            display: flex; gap: 1rem; margin-bottom: 1.5rem; flex-wrap: wrap;
        }
        .mesa-stat {
            background: var(--bg-card); border: 1px solid var(--border);
            border-radius: 8px; padding: 0.8rem 1.2rem;
            display: flex; align-items: center; gap: 0.8rem;
        }
        .mesa-stat-val { font-size: 1.3rem; font-weight: 900; color: var(--gold); }
        .mesa-stat-lbl { font-size: 0.58rem; color: var(--text-faint); letter-spacing: 2px; text-transform: uppercase; }
    </style>
</head>
<body>
<%@ include file="sidebar.jspf" %>

<div class="main-content">
<div class="page-header">
    <div>
        <h1 class="page-title">Mesas</h1>
        <p class="page-subtitle">Gestão e estado em tempo real</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/mesas?acao=nova" class="btn btn-gold">+ Nova Mesa</a>
</div>

<c:if test="${not empty param.msg}">
    <div class="alert alert-success">
        <c:choose>
            <c:when test="${param.msg == 'eliminado'}">Mesa eliminada com sucesso.</c:when>
            <c:otherwise>Operação realizada com sucesso.</c:otherwise>
        </c:choose>
    </div>
</c:if>
<c:if test="${not empty erro}">
    <div class="alert alert-danger"><c:out value="${erro}"/></div>
</c:if>

<%-- Stats rápidas --%>
<div class="mesa-stats">
    <div class="mesa-stat">
        <div>
            <div class="mesa-stat-val">${mesas.size()}</div>
            <div class="mesa-stat-lbl">Total de Mesas</div>
        </div>
    </div>
    <div class="mesa-stat">
        <div>
            <c:set var="cntLivre" value="0"/>
            <c:forEach var="m" items="${mesas}">
                <c:if test="${m.status == 'livre'}"><c:set var="cntLivre" value="${cntLivre + 1}"/></c:if>
            </c:forEach>
            <div class="mesa-stat-val" style="color:#70B070;">${cntLivre}</div>
            <div class="mesa-stat-lbl">Livres</div>
        </div>
    </div>
    <div class="mesa-stat">
        <div>
            <c:set var="cntOcup" value="0"/>
            <c:forEach var="m" items="${mesas}">
                <c:if test="${m.status == 'ocupada'}"><c:set var="cntOcup" value="${cntOcup + 1}"/></c:if>
            </c:forEach>
            <div class="mesa-stat-val" style="color:#D06050;">${cntOcup}</div>
            <div class="mesa-stat-lbl">Ocupadas</div>
        </div>
    </div>
    <div class="mesa-stat">
        <div>
            <c:set var="cntRes" value="0"/>
            <c:forEach var="m" items="${mesas}">
                <c:if test="${m.status == 'reservada'}"><c:set var="cntRes" value="${cntRes + 1}"/></c:if>
            </c:forEach>
            <div class="mesa-stat-val" style="color:#C8A951;">${cntRes}</div>
            <div class="mesa-stat-lbl">Reservadas</div>
        </div>
    </div>
</div>

<%-- Legenda --%>
<div class="legenda">
    <div class="legenda-item"><div class="legenda-dot livre"></div> Livre</div>
    <div class="legenda-item"><div class="legenda-dot ocupada"></div> Ocupada</div>
    <div class="legenda-item"><div class="legenda-dot reservada"></div> Reservada</div>
    <span style="font-size:0.62rem;color:var(--text-faint);">Clica nos botões abaixo de cada mesa para mudar o estado directamente</span>
</div>

<%-- Grid de mesas --%>
<div class="mesas-grid">
    <c:forEach var="m" items="${mesas}">
    <div class="mesa-card ${m.status}">
        <div class="mesa-num">Mesa ${m.numero}</div>
        <div class="mesa-cap">${m.capacidade} lugares</div>
        <div class="mesa-badge ${m.status}">
            <span class="mesa-badge-dot ${m.status}"></span>
            <c:choose>
                <c:when test="${m.status == 'livre'}">Livre</c:when>
                <c:when test="${m.status == 'ocupada'}">Ocupada</c:when>
                <c:otherwise>Reservada</c:otherwise>
            </c:choose>
        </div>

        <%-- Botões de mudança de estado rápida --%>
        <div class="estado-btns">
            <a href="${pageContext.request.contextPath}/admin/mesas?acao=status&id=${m.id}&novoStatus=livre"
               class="estado-btn livre-btn ${m.status == 'livre' ? 'activo' : ''}">
               Livre
            </a>
            <a href="${pageContext.request.contextPath}/admin/mesas?acao=status&id=${m.id}&novoStatus=ocupada"
               class="estado-btn ocupada-btn ${m.status == 'ocupada' ? 'activo' : ''}">
               Ocupada
            </a>
            <a href="${pageContext.request.contextPath}/admin/mesas?acao=status&id=${m.id}&novoStatus=reservada"
               class="estado-btn reservada-btn ${m.status == 'reservada' ? 'activo' : ''}">
               Reservada
            </a>
        </div>

        <%-- Acções --%>
        <div class="mesa-acoes">
            <a href="${pageContext.request.contextPath}/admin/mesas?acao=editar&id=${m.id}"
               class="btn btn-outline btn-sm" style="flex:1;text-align:center;">Editar</a>
            <a href="${pageContext.request.contextPath}/admin/mesas?acao=eliminar&id=${m.id}"
               class="btn btn-danger btn-sm"
               onclick="return confirm('Eliminar Mesa ${m.numero}?')">
               <svg viewBox="0 0 24 24" width="12" height="12" style="stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;vertical-align:middle;">
                   <polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6"/>
               </svg>
            </a>
        </div>
    </div>
    </c:forEach>
    <c:if test="${empty mesas}">
        <div style="grid-column:1/-1;text-align:center;padding:3rem;color:var(--text-faint);">
            Nenhuma mesa registada.
        </div>
    </c:if>
</div>

</div><%-- main-content --%>
</body>
</html>

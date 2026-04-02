<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Minha Área — Muianga's</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { padding-top:70px; background:#0E0C0A; }

        /* ── HERO ── */
        .ca-hero {
            background: linear-gradient(135deg,#120F0C 0%,#1A1410 100%);
            border-bottom: 1px solid #1E1814;
            padding: 3rem 2rem 0;
        }
        .ca-hero-inner {
            max-width: 900px; margin: 0 auto;
            display: flex; align-items: flex-start;
            justify-content: space-between; flex-wrap: wrap; gap: 1.5rem;
        }
        .ca-rotulo { font-size: 0.58rem; letter-spacing: 4px; text-transform: uppercase; color: #3A3028; margin-bottom: 0.5rem; }
        .ca-nome   { font-size: 1.8rem; font-weight: 900; color: #F0EAE0; letter-spacing: 1px; }
        .ca-email  { font-size: 0.75rem; color: #4A4038; margin-top: 0.3rem; }
        .ca-linha  { width: 40px; height: 2px; background: linear-gradient(90deg,#C8A951,transparent); margin: 0.8rem 0 1.5rem; }
        .btn-sair  {
            display: inline-flex; align-items: center; gap: 0.4rem;
            padding: 0.5rem 1.2rem; border-radius: 50px;
            border: 1px solid #2A2218; background: transparent;
            color: #4A4038; font-family: 'Montserrat',sans-serif;
            font-size: 0.68rem; font-weight: 600; cursor: pointer;
            text-decoration: none; transition: all 0.2s; letter-spacing: 1px;
        }
        .btn-sair:hover { border-color: #8A3A2A; color: #E07060; }
        .btn-sair svg   { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 2; }

        /* ── TABS ── */
        .ca-tabs-wrap { max-width: 900px; margin: 0 auto; padding: 0 2rem; }
        .ca-tabs {
            display: flex; gap: 0; border-bottom: 1px solid #1E1814;
            flex-wrap: wrap;
        }
        .ca-tab {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 1rem 1.3rem; font-size: 0.65rem; font-weight: 700;
            letter-spacing: 1.5px; text-transform: uppercase;
            color: #3A3028; text-decoration: none;
            border-bottom: 2px solid transparent; transition: all 0.2s;
            white-space: nowrap;
        }
        .ca-tab svg { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; opacity: 0.6; }
        .ca-tab:hover  { color: #8A7E72; }
        .ca-tab.active { color: #C8A951; border-bottom-color: #C8A951; }
        .ca-tab.active svg { opacity: 1; }

        /* ── CONTEÚDO ── */
        .ca-content { max-width: 900px; margin: 2.5rem auto; padding: 0 2rem; }

        /* ── CARDS RESUMO ── */
        .resumo-grid { display: grid; grid-template-columns: repeat(auto-fill,minmax(190px,1fr)); gap: 1rem; margin-bottom: 2.5rem; }
        .resumo-card {
            background: #161210; border: 1px solid #1E1814;
            border-radius: 10px; padding: 1.4rem;
            text-decoration: none; transition: all 0.25s; display: block;
            position: relative; overflow: hidden;
        }
        .resumo-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; height: 1px;
            background: linear-gradient(90deg,transparent,rgba(200,169,81,0.3),transparent);
            opacity: 0; transition: opacity 0.25s;
        }
        .resumo-card:hover { border-color: #3A2E22; transform: translateY(-3px); box-shadow: 0 8px 24px rgba(0,0,0,0.4); }
        .resumo-card:hover::before { opacity: 1; }
        .resumo-icone {
            width: 38px; height: 38px; border-radius: 8px;
            background: rgba(200,169,81,0.08); border: 1px solid rgba(200,169,81,0.15);
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 1rem;
        }
        .resumo-icone svg { width: 18px; height: 18px; stroke: #C8A951; fill: none; stroke-width: 1.8; stroke-linecap: round; stroke-linejoin: round; }
        .resumo-val   { font-size: 1.6rem; font-weight: 900; color: #C8A951; line-height: 1; }
        .resumo-label { font-size: 0.58rem; letter-spacing: 2px; text-transform: uppercase; color: #3A3028; margin-top: 0.4rem; }

        /* ── SECÇÃO TÍTULO ── */
        .sec-titulo { font-size: 0.58rem; letter-spacing: 4px; text-transform: uppercase; color: #3A3028; margin-bottom: 1.2rem; display: flex; align-items: center; gap: 0.8rem; }
        .sec-titulo::after { content: ''; flex: 1; height: 1px; background: #1E1814; }

        /* ── PEDIDO CARD ── */
        .pedido-card {
            background: #161210; border: 1px solid #1E1814;
            border-radius: 10px; padding: 1.4rem;
            margin-bottom: 1rem; transition: border-color 0.2s;
        }
        .pedido-card:hover { border-color: #2A2218; }
        .pedido-header { display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 1rem; }
        .pedido-id    { font-size: 0.6rem; letter-spacing: 3px; color: #3A3028; text-transform: uppercase; }
        .pedido-data  { font-size: 0.72rem; color: #4A4038; margin-top: 0.2rem; }
        .pedido-total { font-size: 1.1rem; font-weight: 900; color: #C8A951; }

        /* Progresso */
        .prog-wrap  { margin: 1rem 0 0.8rem; }
        .prog-track { display: flex; align-items: center; gap: 0; }
        .prog-step  { display: flex; flex-direction: column; align-items: center; flex: 1; }
        .prog-dot   { width: 10px; height: 10px; border-radius: 50%; background: #1E1814; border: 1.5px solid #2A2218; transition: all 0.3s; position: relative; z-index: 1; }
        .prog-dot.done  { background: #C8A951; border-color: #C8A951; box-shadow: 0 0 6px rgba(200,169,81,0.4); }
        .prog-dot.atual { background: rgba(200,169,81,0.2); border-color: #C8A951; }
        .prog-line  { flex: 1; height: 1px; background: #1E1814; margin-top: -5px; }
        .prog-line.done { background: #C8A951; }
        .prog-labels { display: flex; margin-top: 0.5rem; }
        .prog-lbl   { flex: 1; font-size: 0.55rem; color: #3A3028; text-align: center; letter-spacing: 1px; text-transform: uppercase; }
        .prog-lbl.done  { color: #6A5E44; }
        .prog-lbl.atual { color: #C8A951; font-weight: 700; }
        .prog-status { font-size: 0.7rem; font-weight: 700; color: #C8A951; margin-top: 0.6rem; }

        /* Badge pagamento */
        .badge-pag { display: inline-flex; align-items: center; gap: 0.35rem; padding: 0.22rem 0.7rem; border-radius: 20px; font-size: 0.6rem; font-weight: 700; letter-spacing: 0.5px; }
        .badge-pag svg { width: 10px; height: 10px; stroke: currentColor; fill: none; stroke-width: 2; }
        .bp-aprovado  { background: rgba(80,160,80,0.12);  color: #60A860; border: 1px solid rgba(80,160,80,0.2); }
        .bp-pendente  { background: rgba(200,169,81,0.1);  color: #C8A951; border: 1px solid rgba(200,169,81,0.2); }
        .bp-rejeitado { background: rgba(138,58,42,0.12);  color: #C06050; border: 1px solid rgba(138,58,42,0.2); }
        .bp-comprovativo_enviado { background: rgba(80,130,200,0.1); color: #6090C8; border: 1px solid rgba(80,130,200,0.2); }

        /* ── ENDEREÇOS ── */
        .end-card {
            background: #161210; border: 1px solid #1E1814;
            border-radius: 10px; padding: 1.2rem 1.4rem;
            margin-bottom: 0.8rem; display: flex;
            justify-content: space-between; align-items: center;
            gap: 1rem; flex-wrap: wrap; transition: border-color 0.2s;
        }
        .end-card:hover { border-color: #2A2218; }
        .end-icone { width: 36px; height: 36px; border-radius: 8px; background: rgba(200,169,81,0.06); border: 1px solid rgba(200,169,81,0.12); display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .end-icone svg { width: 16px; height: 16px; stroke: #C8A951; fill: none; stroke-width: 1.8; stroke-linecap: round; stroke-linejoin: round; }
        .end-nome  { font-size: 0.75rem; font-weight: 700; color: #C8A951; margin-bottom: 0.2rem; }
        .end-info  { font-size: 0.8rem; color: #8A7E72; }
        .end-zona  { font-size: 0.62rem; color: #4A4038; margin-top: 0.15rem; }
        .end-def   { font-size: 0.58rem; background: rgba(200,169,81,0.08); color: #C8A951; border: 1px solid rgba(200,169,81,0.15); border-radius: 20px; padding: 0.15rem 0.6rem; font-weight: 700; letter-spacing: 1px; }
        .btn-del   { display: inline-flex; align-items: center; justify-content: center; width: 32px; height: 32px; border-radius: 8px; background: rgba(138,58,42,0.08); border: 1px solid rgba(138,58,42,0.2); color: #A06050; cursor: pointer; transition: all 0.2s; flex-shrink: 0; }
        .btn-del svg { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; }
        .btn-del:hover { background: #8A3A2A; color: #fff; border-color: #8A3A2A; }

        /* Form add */
        .form-add { background: #120F0C; border: 1px dashed #252018; border-radius: 10px; padding: 1.4rem; margin-bottom: 1.5rem; }
        .form-add-titulo { font-size: 0.58rem; letter-spacing: 3px; text-transform: uppercase; color: #3A3028; margin-bottom: 1.2rem; }

        /* ── FAVORITOS ── */
        .fav-grid { display: grid; grid-template-columns: repeat(auto-fill,minmax(160px,1fr)); gap: 1rem; }
        .fav-card { background: #161210; border: 1px solid #1E1814; border-radius: 10px; overflow: hidden; position: relative; transition: all 0.25s; }
        .fav-card:hover { border-color: #3A2E22; transform: translateY(-3px); }
        .fav-img  { width: 100%; height: 110px; object-fit: cover; }
        .fav-placeholder { width: 100%; height: 110px; background: #1A1510; display: flex; align-items: center; justify-content: center; }
        .fav-placeholder svg { width: 32px; height: 32px; stroke: #3A3028; fill: none; stroke-width: 1.5; stroke-linecap: round; stroke-linejoin: round; }
        .fav-body  { padding: 0.8rem; }
        .fav-nome  { font-size: 0.82rem; font-weight: 700; color: #F0EAE0; }
        .fav-preco { font-size: 0.85rem; font-weight: 900; color: #C8A951; margin-top: 0.2rem; }
        .fav-rem   { position: absolute; top: 0.5rem; right: 0.5rem; width: 26px; height: 26px; border-radius: 50%; background: rgba(14,12,10,0.85); border: 1px solid #2A2218; color: #6A5E52; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s; }
        .fav-rem svg { width: 12px; height: 12px; stroke: currentColor; fill: none; stroke-width: 2.5; stroke-linecap: round; }
        .fav-rem:hover { background: #8A3A2A; border-color: #8A3A2A; color: #fff; }

        /* ── AVALIAÇÕES ── */
        .aval-card { background: #161210; border: 1px solid #1E1814; border-radius: 10px; padding: 1.4rem; margin-bottom: 1rem; }
        .estrelas-gold { display: flex; gap: 0.2rem; margin: 0.5rem 0 0.8rem; }
        .estrela-svg { width: 16px; height: 16px; }
        .estrela-svg.cheia  path { fill: #C8A951; stroke: #C8A951; }
        .estrela-svg.vazia  path { fill: none; stroke: #3A3028; stroke-width: 1.5; }
        .aval-coment { font-size: 0.82rem; color: #8A7E72; font-style: italic; line-height: 1.6; }
        .aval-data   { font-size: 0.62rem; color: #3A3028; margin-top: 0.6rem; letter-spacing: 1px; }

        /* Form avaliação */
        .form-aval { background: #120F0C; border: 1px dashed #252018; border-radius: 10px; padding: 1.4rem; margin-bottom: 1.5rem; }
        .estrelas-picker { display: flex; gap: 0.4rem; margin-bottom: 1rem; }
        .pick-star { cursor: pointer; transition: transform 0.15s; }
        .pick-star:hover { transform: scale(1.15); }
        .pick-star svg path { fill: none; stroke: #3A3028; stroke-width: 1.5; transition: all 0.2s; }
        .pick-star.sel svg path { fill: #C8A951; stroke: #C8A951; }

        /* Geral */
        .vazio { text-align: center; padding: 3.5rem 1rem; color: #3A3028; font-size: 0.85rem; line-height: 2; }
        .vazio a { color: #C8A951; }
        .msg-sucesso { background: rgba(90,138,90,0.08); border: 1px solid rgba(90,138,90,0.2); color: #70A870; border-radius: 8px; padding: 0.8rem 1.1rem; margin-bottom: 1.2rem; font-size: 0.82rem; display: flex; align-items: center; gap: 0.6rem; }
        .msg-sucesso svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2; flex-shrink: 0; }
        .msg-bemvindo { background: rgba(200,169,81,0.06); border: 1px solid rgba(200,169,81,0.15); color: #C8A951; border-radius: 8px; padding: 1rem 1.2rem; margin-bottom: 1.5rem; font-size: 0.82rem; }

        @media(max-width:600px) { .ca-tabs-wrap,.ca-content{ padding:0 1rem; } .ca-tab{ padding:0.7rem 0.9rem; font-size:0.6rem; } }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="navbar-brand">MUIANGA'S <span>Bar &amp; Restaurante</span></div>
    <ul class="navbar-nav">
        <li><a href="${pageContext.request.contextPath}/">Início</a></li>
        <li><a href="${pageContext.request.contextPath}/menu">Menu</a></li>
        <li><a href="${pageContext.request.contextPath}/delivery">Delivery</a></li>
        <li><a href="${pageContext.request.contextPath}/cliente/area" class="active">${cliente.nome}</a></li>
    </ul>
</nav>

<!-- HERO -->
<div class="ca-hero">
    <div class="ca-hero-inner">
        <div>
            <div class="ca-rotulo">Área do Cliente</div>
            <div class="ca-nome"><c:out value="${cliente.nome}"/></div>
            <div class="ca-email"><c:out value="${cliente.email}"/></div>
            <div class="ca-linha"></div>
        </div>
        <a href="${pageContext.request.contextPath}/cliente/logout" class="btn-sair">
            <svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9"/></svg>
            Sair
        </a>
    </div>

    <!-- TABS -->
    <div class="ca-tabs-wrap">
        <div class="ca-tabs">
            <a href="?aba=inicio"    class="ca-tab ${aba=='inicio'    ?'active':''}">
                <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                Início
            </a>
            <a href="?aba=historico" class="ca-tab ${aba=='historico' ?'active':''}">
                <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
                Pedidos
            </a>
            <a href="?aba=reservas" class="ca-tab ${aba=='reservas' ?'active':''}">
                <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                Reservas
            </a>
            <a href="?aba=enderecos" class="ca-tab ${aba=='enderecos' ?'active':''}">
                <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
                Endereços
            </a>
            <a href="?aba=favoritos" class="ca-tab ${aba=='favoritos' ?'active':''}">
                <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>
                Favoritos
            </a>
            <a href="?aba=avaliacoes" class="ca-tab ${aba=='avaliacoes'?'active':''}">
                <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                Avaliações
            </a>
        </div>
    </div>
</div>

<div class="ca-content">

<c:if test="${not empty erro}">
    <div class="alert alert-danger"><c:out value="${erro}"/></div>
</c:if>

<%-- ══ INÍCIO ══ --%>
<c:if test="${aba=='inicio'}">
    <c:if test="${not empty param.bemvindo}">
        <div class="msg-bemvindo">Bem-vindo, <strong><c:out value="${cliente.nome}"/></strong>! A tua conta está pronta.</div>
    </c:if>
    <div class="resumo-grid">
        <a href="?aba=historico" class="resumo-card">
            <div class="resumo-icone">
                <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
            </div>
            <div class="resumo-val">${pedidos.size()}</div>
            <div class="resumo-label">Pedidos feitos</div>
        </a>
        <a href="?aba=enderecos" class="resumo-card">
            <div class="resumo-icone">
                <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
            </div>
            <div class="resumo-val">${endCount}</div>
            <div class="resumo-label">Endereços guardados</div>
        </a>
        <a href="?aba=favoritos" class="resumo-card">
            <div class="resumo-icone">
                <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>
            </div>
            <div class="resumo-val">${favCount}</div>
            <div class="resumo-label">Favoritos</div>
        </a>
        <a href="${pageContext.request.contextPath}/delivery" class="resumo-card">
            <div class="resumo-icone">
                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
            </div>
            <div class="resumo-val">+</div>
            <div class="resumo-label">Novo pedido</div>
        </a>
    </div>

    <div class="sec-titulo">Últimos pedidos</div>
    <c:forEach var="p" items="${pedidos}" varStatus="st">
        <c:if test="${st.index < 3}">
            <%@ include file="cliente-pedido-card.jspf" %>
        </c:if>
    </c:forEach>
    <c:if test="${empty pedidos}">
        <div class="vazio">Ainda não fizeste nenhum pedido.<br><a href="${pageContext.request.contextPath}/delivery">Fazer primeiro pedido →</a></div>
    </c:if>
</c:if>

<%-- ══ RESERVAS ══ --%>
<c:if test="${aba=='reservas'}">
    <div class="sec-titulo">As minhas reservas</div>
    <c:forEach var="r" items="${reservas}">
    <div class="pedido-card">
        <div class="pedido-header">
            <div>
                <div class="pedido-id">Reserva #${r.id}</div>
                <div class="pedido-data">
                    <fmt:formatDate value="${r.dataReserva}" pattern="dd/MM/yyyy"/> às
                    <fmt:formatDate value="${r.horaReserva}" pattern="HH:mm"/>
                    · ${r.numPessoas} pessoa${r.numPessoas > 1 ? 's' : ''}
                </div>
            </div>
            <span class="badge-pag ${r.status == 'confirmada' ? 'bp-aprovado' : r.status == 'cancelada' || r.status == 'nao_compareceu' ? 'bp-rejeitado' : 'bp-pendente'}">
                <c:choose>
                    <c:when test="${r.status == 'confirmada'}">Confirmada</c:when>
                    <c:when test="${r.status == 'cancelada'}">Cancelada</c:when>
                    <c:when test="${r.status == 'nao_compareceu'}">Não compareceu</c:when>
                    <c:otherwise>Pendente</c:otherwise>
                </c:choose>
            </span>
        </div>
        <c:if test="${not empty r.observacoes}">
            <div style="font-size:0.75rem;color:#4A4038;font-style:italic;margin-top:0.4rem;">"<c:out value="${r.observacoes}"/>"</div>
        </c:if>
        <c:if test="${r.status == 'pendente'}">
            <div style="margin-top:0.8rem;">
                <a href="${pageContext.request.contextPath}/reserva" style="font-size:0.68rem;color:#C8A951;text-decoration:none;border-bottom:1px solid rgba(200,169,81,0.3);padding-bottom:1px;">
                    Para cancelar contacta-nos →
                </a>
            </div>
        </c:if>
    </div>
    </c:forEach>
    <c:if test="${empty reservas}">
        <div class="vazio">Ainda não fizeste nenhuma reserva.<br><a href="${pageContext.request.contextPath}/reserva">Fazer reserva →</a></div>
    </c:if>
</c:if>

<%-- ══ HISTÓRICO ══ --%>
<c:if test="${aba=='historico'}">
    <div class="sec-titulo">Todos os pedidos</div>
    <c:forEach var="p" items="${pedidos}">
        <%@ include file="cliente-pedido-card.jspf" %>
    </c:forEach>
    <c:if test="${empty pedidos}">
        <div class="vazio">Ainda não fizeste nenhum pedido.<br><a href="${pageContext.request.contextPath}/delivery">Fazer primeiro pedido →</a></div>
    </c:if>
</c:if>

<%-- ══ ENDEREÇOS ══ --%>
<c:if test="${aba=='enderecos'}">
    <c:if test="${not empty param.sucesso}">
        <div class="msg-sucesso">
            <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
            Endereço guardado com sucesso!
        </div>
    </c:if>
    <div class="form-add">
        <div class="form-add-titulo">Adicionar endereço</div>
        <form method="post" action="${pageContext.request.contextPath}/cliente/area">
            <input type="hidden" name="acao" value="adicionarEndereco">
            <div class="grid-2">
                <div class="form-group">
                    <label class="form-label">Nome *</label>
                    <input type="text" name="nomeEnd" class="form-control" placeholder="Casa, Trabalho...">
                </div>
                <div class="form-group">
                    <label class="form-label">Zona</label>
                    <select name="zonaId" class="form-control">
                        <option value="">Seleccione</option>
                        <c:forEach var="z" items="${zonas}">
                            <option value="${z.id}"><c:out value="${z.nome}"/></option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Morada / Referência *</label>
                <input type="text" name="morada" class="form-control" placeholder="Ex: Perto do Mercado Central">
            </div>
            <div class="form-group" style="display:flex;align-items:center;gap:0.5rem;">
                <input type="checkbox" name="predefinido" id="chkPred" style="accent-color:#C8A951;width:15px;height:15px;">
                <label for="chkPred" class="form-label" style="margin:0;cursor:pointer;text-transform:none;letter-spacing:0;font-size:0.78rem;">Definir como predefinido</label>
            </div>
            <button type="submit" class="btn btn-gold">Guardar endereço</button>
        </form>
    </div>

    <div class="sec-titulo">Os meus endereços</div>
    <c:forEach var="e" items="${enderecos}">
    <div class="end-card">
        <div class="end-icone">
            <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
        </div>
        <div style="flex:1">
            <div class="end-nome">
                <c:out value="${e.nome}"/>
                <c:if test="${e.predefinido}"><span class="end-def" style="margin-left:0.5rem;">Predefinido</span></c:if>
            </div>
            <div class="end-info"><c:out value="${e.morada}"/></div>
            <c:if test="${not empty e.zonaNome}">
                <div class="end-zona"><c:out value="${e.zonaNome}"/></div>
            </c:if>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/cliente/area" style="margin:0">
            <input type="hidden" name="acao" value="eliminarEndereco">
            <input type="hidden" name="id"   value="${e.id}">
            <button type="submit" class="btn-del" onclick="return confirm('Eliminar este endereço?')">
                <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6"/><path d="M10 11v6M14 11v6"/></svg>
            </button>
        </form>
    </div>
    </c:forEach>
    <c:if test="${empty enderecos}">
        <div class="vazio">Ainda não tens endereços guardados.</div>
    </c:if>
</c:if>

<%-- ══ FAVORITOS ══ --%>
<c:if test="${aba=='favoritos'}">
    <c:choose>
        <c:when test="${not empty favoritos}">
            <div class="sec-titulo">Os meus favoritos</div>
            <div class="fav-grid">
                <c:forEach var="p" items="${favoritos}">
                <div class="fav-card">
                    <c:choose>
                        <c:when test="${not empty p.imagem}">
                            <img class="fav-img" src="${pageContext.request.contextPath}/imagens_produtos/${p.imagem}" alt="produto">
                        </c:when>
                        <c:otherwise>
                            <div class="fav-placeholder">
                                <svg viewBox="0 0 24 24"><path d="M18 8h1a4 4 0 010 8h-1"/><path d="M2 8h16v9a4 4 0 01-4 4H6a4 4 0 01-4-4V8z"/><line x1="6" y1="1" x2="6" y2="4"/><line x1="10" y1="1" x2="10" y2="4"/><line x1="14" y1="1" x2="14" y2="4"/></svg>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="fav-body">
                        <div class="fav-nome"><c:out value="${p.nome}"/></div>
                        <div class="fav-preco"><fmt:formatNumber value="${p.preco}" pattern="#,##0.00"/> MZN</div>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/cliente/area" style="margin:0">
                        <input type="hidden" name="acao"      value="toggleFavorito">
                        <input type="hidden" name="produtoId" value="${p.id}">
                        <button type="submit" class="fav-rem" title="Remover">
                            <svg viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                        </button>
                    </form>
                </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="vazio">Ainda não tens favoritos.<br><a href="${pageContext.request.contextPath}/menu">Ver menu →</a></div>
        </c:otherwise>
    </c:choose>
</c:if>

<%-- ══ AVALIAÇÕES ══ --%>
<c:if test="${aba=='avaliacoes'}">
    <c:if test="${not empty param.sucesso}">
        <div class="msg-sucesso">
            <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
            Avaliação enviada! Obrigado pelo teu feedback.
        </div>
    </c:if>

    <c:forEach var="p" items="${pedidos}">
        <c:if test="${p.status=='entregue'}"><c:set var="temEntregue" value="true"/></c:if>
    </c:forEach>

    <c:if test="${temEntregue}">
    <div class="form-aval">
        <div class="form-add-titulo">Nova avaliação</div>
        <form method="post" action="${pageContext.request.contextPath}/cliente/area">
            <input type="hidden" name="acao" value="avaliar">
            <div class="form-group">
                <label class="form-label">Pedido</label>
                <select name="pedidoId" class="form-control">
                    <c:forEach var="p" items="${pedidos}">
                        <c:if test="${p.status=='entregue'}">
                            <option value="${p.id}">Pedido #${p.id} — <fmt:formatDate value="${p.dataHora}" pattern="dd/MM/yyyy"/></option>
                        </c:if>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">Classificação</label>
                <div class="estrelas-picker" id="picker">
                    <c:forEach begin="1" end="5" var="i">
                    <span class="pick-star" data-val="${i}" onclick="selEstrela(${i})">
                        <svg class="estrela-svg" viewBox="0 0 24 24" width="28" height="28">
                            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                        </svg>
                    </span>
                    </c:forEach>
                </div>
                <input type="hidden" name="estrelas" id="hEstrelas" value="5">
            </div>
            <div class="form-group">
                <label class="form-label">Comentário</label>
                <textarea name="comentario" class="form-control" rows="3" placeholder="Conta-nos a tua experiência..."></textarea>
            </div>
            <button type="submit" class="btn btn-gold">Enviar avaliação</button>
        </form>
    </div>
    </c:if>

    <div class="sec-titulo">As minhas avaliações</div>
    <c:forEach var="a" items="${avaliacoes}">
    <div class="aval-card">
        <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:0.5rem;">
            <span style="font-size:0.62rem;color:#3A3028;letter-spacing:2px;text-transform:uppercase;">Pedido #${a.pedidoId}</span>
            <span style="font-size:0.62rem;color:#3A3028;"><fmt:formatDate value="${a.dataAvalia}" pattern="dd/MM/yyyy"/></span>
        </div>
        <div class="estrelas-gold">
            <c:forEach begin="1" end="5" var="i">
                <svg class="estrela-svg ${i <= a.estrelas ? 'cheia' : 'vazia'}" viewBox="0 0 24 24" width="16" height="16">
                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                </svg>
            </c:forEach>
        </div>
        <c:if test="${not empty a.comentario}">
            <div class="aval-coment">"<c:out value="${a.comentario}"/>"</div>
        </c:if>
        <div class="aval-data"><fmt:formatDate value="${a.dataAvalia}" pattern="dd 'de' MMMM 'de' yyyy" /></div>
    </div>
    </c:forEach>
    <c:if test="${empty avaliacoes}">
        <div class="vazio">Ainda não fizeste nenhuma avaliação.</div>
    </c:if>
</c:if>

</div>

<footer style="margin-top:4rem;">
    <strong>MUIANGA'S</strong> Bar &amp; Restaurante · &copy; 2026
</footer>

<script>
function selEstrela(val) {
    document.getElementById('hEstrelas').value = val;
    document.querySelectorAll('.pick-star').forEach(function(s) {
        var v = parseInt(s.getAttribute('data-val'));
        s.classList.toggle('sel', v <= val);
    });
}
selEstrela(5);
</script>
</body>
</html>

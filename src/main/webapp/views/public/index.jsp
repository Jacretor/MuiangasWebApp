<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Muianga's Bar &amp; Restaurante — Chimoio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ── HERO ── */
        .hero-main {
            position: relative;
            min-height: 100vh;
            display: flex; align-items: center; justify-content: center;
            overflow: hidden; background: #0a0806;
        }
        .hero-bg {
            position: absolute; inset: 0;
            background-image: url('${pageContext.request.contextPath}/imagens_site/fachada.jpeg');
            background-size: cover; background-position: center;
            filter: brightness(0.22) blur(3px);
            transform: scale(1.05);
            transition: transform 10s ease;
        }
        .hero-main:hover .hero-bg { transform: scale(1.04); }
        .hero-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to bottom,
                rgba(10,8,6,0.3) 0%,
                rgba(10,8,6,0.5) 60%,
                rgba(10,8,6,0.9) 100%);
        }
        .hero-content {
            position: relative; z-index: 2;
            text-align: center; padding: 2rem;
        }
        .hero-eyebrow {
            font-size: 0.7rem; letter-spacing: 6px;
            text-transform: uppercase;
            color: rgba(200,169,81,0.7); margin-bottom: 1.5rem;
        }
        .hero-name {
            font-size: clamp(4rem, 12vw, 8rem);
            font-weight: 900; letter-spacing: 10px;
            color: #fff; line-height: 1;
            text-shadow: 0 4px 40px rgba(0,0,0,0.6);
        }
        .hero-name span { color: #C8A951; }
        .hero-line {
            width: 60px; height: 2px;
            background: linear-gradient(90deg, transparent, #C8A951, transparent);
            margin: 1.8rem auto;
        }
        .hero-tagline {
            font-size: 0.75rem; letter-spacing: 5px;
            text-transform: uppercase;
            color: rgba(255,255,255,0.35); margin-bottom: 3rem;
        }
        .hero-btns { display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap; }
        .btn-hero-primary {
            background: transparent; color: #C8A951;
            border: 1.5px solid #C8A951;
            padding: 0.85rem 2.2rem; border-radius: 50px;
            font-weight: 700; font-size: 0.75rem;
            letter-spacing: 2px; text-transform: uppercase;
            text-decoration: none; transition: all 0.25s;
        }
        .btn-hero-primary:hover {
            background: #C8A951; color: #0a0806;
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(200,169,81,0.3);
        }
        .btn-hero-outline {
            background: transparent; color: rgba(255,255,255,0.6);
            border: 1.5px solid rgba(255,255,255,0.2);
            padding: 0.85rem 2.2rem; border-radius: 50px;
            font-weight: 600; font-size: 0.75rem;
            letter-spacing: 2px; text-transform: uppercase;
            text-decoration: none; transition: all 0.25s;
        }
        .btn-hero-outline:hover { border-color: #C8A951; color: #C8A951; }
        .scroll-down {
            position: absolute; bottom: 2.5rem; left: 50%;
            transform: translateX(-50%); z-index: 2;
            color: rgba(255,255,255,0.25); font-size: 0.65rem;
            letter-spacing: 4px; text-transform: uppercase;
            animation: float 2.5s ease-in-out infinite;
        }
        @keyframes float {
            0%,100% { transform: translateX(-50%) translateY(0); }
            50% { transform: translateX(-50%) translateY(10px); }
        }

        /* ── NAVBAR SOBRE HERO ── */
        .navbar-over {
            position: absolute; top: 0; left: 0; right: 0;
            background: transparent; border-bottom: none;
            z-index: 10; padding: 1.8rem 2.5rem;
            display: flex; align-items: center; justify-content: space-between;
            transition: all 0.4s;
        }
        .navbar-over .brand {
            font-size: 1rem; font-weight: 900;
            letter-spacing: 4px; color: #fff;
        }
        .navbar-over .brand span {
            color: rgba(255,255,255,0.3);
            font-weight: 300; font-size: 0.68rem; margin-left: 0.5rem;
        }
        .navbar-over ul { display: flex; gap: 2rem; align-items: center; }
        .navbar-over ul a {
            font-size: 0.72rem; font-weight: 600;
            letter-spacing: 2px; text-transform: uppercase;
            color: rgba(255,255,255,0.55); transition: color 0.2s;
        }
        .navbar-over ul a:hover { color: #C8A951; }
        .btn-nav-area {
            background: rgba(200,169,81,0.15);
            border: 1px solid rgba(200,169,81,0.4);
            color: #C8A951 !important;
            padding: 0.45rem 1.1rem; border-radius: 2px;
            font-size: 0.68rem !important;
        }
        .btn-nav-area:hover { background: #C8A951 !important; color: #0a0806 !important; }

        /* ── SOBRE ── */
        .sobre-sec {
            background: #120F0C;
            padding: 7rem 2rem;
        }
        .sobre-wrap {
            max-width: 1100px; margin: 0 auto;
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 5rem; align-items: center;
        }
        .sobre-foto { position: relative; }
        .sobre-foto img {
            width: 100%; height: 480px;
            object-fit: cover; border-radius: 3px;
            filter: brightness(0.9);
        }
        .sobre-accent {
            position: absolute; bottom: -20px; right: -20px;
            width: 140px; height: 140px;
            background: linear-gradient(135deg, #6B4C2A, #C8A951);
            border-radius: 3px; z-index: -1; opacity: 0.6;
        }
        .sobre-bud {
            position: absolute; top: 1.5rem; right: 1.5rem;
            background: rgba(10,8,6,0.85);
            border: 1px solid rgba(200,169,81,0.3);
            border-radius: 3px; padding: 0.6rem 1rem;
            font-size: 0.65rem; font-weight: 700;
            letter-spacing: 2px; text-transform: uppercase;
            color: #C8A951;
        }
        .secao-rotulo {
            font-size: 0.65rem; letter-spacing: 5px;
            text-transform: uppercase; color: #C8A951;
            margin-bottom: 1rem;
            display: flex; align-items: center; gap: 0.8rem;
        }
        .secao-rotulo::before {
            content: ''; width: 30px; height: 1px; background: #C8A951;
        }
        .secao-h2 {
            font-size: clamp(1.8rem, 3.5vw, 2.8rem);
            font-weight: 900; color: #F0EAE0; line-height: 1.2;
            margin-bottom: 1.5rem;
        }
        .secao-p {
            color: #6A5E52; line-height: 1.9;
            font-size: 0.9rem; margin-bottom: 1rem;
        }
        .sobre-nums {
            display: grid; grid-template-columns: repeat(3,1fr);
            gap: 1rem; margin-top: 2.5rem;
            padding-top: 2rem; border-top: 1px solid #1E1A16;
        }
        .num-item { text-align: center; }
        .num-val { font-size: 2rem; font-weight: 900; color: #C8A951; }
        .num-desc { font-size: 0.65rem; color: #4A4038; text-transform: uppercase; letter-spacing: 2px; margin-top: 0.2rem; }

        /* ── DESTAQUES ── */
        .destaques-sec { background: #0E0C0A; padding: 7rem 2rem; }
        .sec-header { text-align: center; max-width: 500px; margin: 0 auto 4rem; }
        .destaques-wrap {
            max-width: 1100px; margin: 0 auto;
            display: grid; grid-template-columns: repeat(3,1fr);
            gap: 3px;
        }
        .dest-item { position: relative; overflow: hidden; cursor: pointer; }
        .dest-item img {
            width: 100%; height: 340px;
            object-fit: cover; display: block;
            transition: transform 0.6s ease, filter 0.4s ease;
            filter: brightness(0.6) saturate(0.8);
        }
        .dest-item:hover img {
            transform: scale(1.07); filter: brightness(0.4) saturate(0.6);
        }
        .dest-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(10,8,6,0.95) 0%, rgba(10,8,6,0.1) 50%, transparent 100%);
        }
        .dest-info {
            position: absolute; bottom: 0; left: 0; right: 0;
            padding: 2rem 1.5rem;
            transform: translateY(5px);
            transition: transform 0.3s ease;
        }
        .dest-item:hover .dest-info { transform: translateY(0); }
        .dest-num {
            font-size: 0.6rem; letter-spacing: 4px;
            text-transform: uppercase; color: #C8A951;
            margin-bottom: 0.4rem;
        }
        .dest-titulo { font-size: 1.05rem; font-weight: 800; color: #fff; margin-bottom: 0.3rem; }
        .dest-icone { margin-bottom: 0.6rem; opacity: 0.85; }
        .dest-desc { font-size: 0.78rem; color: rgba(255,255,255,0.45); }

        /* ── CONTACTOS ── */
        .contact-sec { background: #0A0806; padding: 7rem 2rem; }
        .contact-wrap {
            max-width: 1100px; margin: 0 auto;
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 6rem; align-items: start;
        }
        .contact-h2 { font-size: 2.2rem; font-weight: 900; color: #F0EAE0; margin-bottom: 0.5rem; }
        .contact-p { color: #5A4E44; font-size: 0.88rem; line-height: 1.8; margin-bottom: 2.5rem; }
        .contact-items { display: flex; flex-direction: column; gap: 0; }
        .contact-item {
            display: flex; align-items: center; gap: 1.2rem;
            padding: 1.1rem 0; border-bottom: 1px solid #181410;
        }
        .contact-item:last-child { border-bottom: none; }
        .c-icon {
            width: 46px; height: 46px; flex-shrink: 0;
            background: #161210; border: 1px solid #251E18;
            border-radius: 3px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem;
        }
        .c-label { font-size: 0.62rem; text-transform: uppercase; letter-spacing: 2px; color: #3A3028; }
        .c-val { font-size: 0.9rem; color: #B8ACA0; font-weight: 600; margin-top: 0.15rem; }

        .horario-box {
            background: #161210; border: 1px solid #201A14;
            border-radius: 4px; padding: 2rem;
        }
        .horario-label {
            font-size: 0.62rem; letter-spacing: 4px;
            text-transform: uppercase; color: #C8A951;
            margin-bottom: 1.8rem;
        }
        .h-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 0.7rem 0; border-bottom: 1px solid #1A1410;
            font-size: 0.82rem;
        }
        .h-row:last-of-type { border-bottom: none; }
        .h-dia { color: #4A4038; }
        .h-hora { color: #C0B4A8; font-weight: 700; }
        .h-open { color: #C8A951; font-size: 0.6rem; letter-spacing: 2px; text-transform: uppercase; }
        .h-action { margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #1A1410; }

        /* ── FOOTER ── */
        .footer-wrap {
            background: #060504; border-top: 1px solid #141008;
            padding: 2rem 2.5rem;
            display: flex; align-items: center; justify-content: space-between;
            flex-wrap: wrap; gap: 1rem;
        }
        .f-brand { font-size: 1rem; font-weight: 900; letter-spacing: 4px; color: #C8A951; }
        .f-copy { font-size: 0.7rem; color: #2A2218; }
        .f-links { display: flex; gap: 1.5rem; }
        .f-links a { font-size: 0.65rem; letter-spacing: 2px; color: #2A2218; text-transform: uppercase; transition: color 0.2s; }
        .f-links a:hover { color: #C8A951; }


        /* ── AVALIAÇÕES ── */
        .aval-sec { background: #120F0C; padding: 7rem 2rem; }
        .aval-grid {
            max-width: 1100px; margin: 2.5rem auto 0;
            display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
        }
        .aval-card {
            background: #0E0C0A; border: 1px solid #1E1814;
            border-radius: 8px; padding: 1.5rem;
            transition: border-color 0.3s;
        }
        .aval-card:hover { border-color: #6B4C2A; }
        .aval-estrelas { color: #C8A951; font-size: 1rem; letter-spacing: 2px; margin-bottom: 0.8rem; }
        .aval-texto {
            font-size: 0.88rem; color: #8A7E72; line-height: 1.7;
            font-style: italic; margin-bottom: 1rem;
        }
        .aval-autor { display: flex; align-items: center; gap: 0.8rem; }
        .aval-avatar {
            width: 36px; height: 36px; border-radius: 50%;
            background: linear-gradient(135deg, #6B4C2A, #C8A951);
            display: flex; align-items: center; justify-content: center;
            font-size: 0.85rem; font-weight: 900; color: #0E0C0A;
            flex-shrink: 0;
        }
        .aval-nome { font-size: 0.78rem; font-weight: 700; color: #C0B4A8; }
        .aval-data { font-size: 0.65rem; color: #3A3028; margin-top: 0.1rem; }
        .aval-vazio { text-align:center; color:#3A3028; font-size:0.85rem; padding:2rem; }
        @media (max-width: 768px) {
            .sobre-wrap, .contact-wrap { grid-template-columns: 1fr; gap: 2.5rem; }
            .destaques-wrap { grid-template-columns: 1fr; }
            .navbar-over ul { gap: 1rem; }
            .footer-wrap { flex-direction: column; text-align: center; }
        }
        
        /* Mobile navbar */
@media (max-width: 768px) {
    .navbar-over ul {
        display: none;
        position: absolute;
        top: 100%; left: 0; right: 0;
        background: rgba(10,8,6,0.98);
        flex-direction: column;
        padding: 1rem 0;
        border-bottom: 1px solid #1E1814;
        gap: 0;
    }
    .navbar-over ul.mobile-open { display: flex; }
    .navbar-over ul li { width: 100%; }
    .navbar-over ul a {
        display: block;
        padding: 0.9rem 2rem;
        border-bottom: 1px solid #141008;
        color: rgba(255,255,255,0.6) !important;
        font-size: 0.8rem !important;
    }
    .navbar-over ul a:hover { color: #C8A951 !important; }
    .hero-name { font-size: clamp(2.5rem, 15vw, 5rem) !important; }
    .sobre-wrap, .contact-wrap { grid-template-columns: 1fr !important; gap: 2rem !important; }
    .destaques-wrap { grid-template-columns: 1fr !important; }
    .hero-btns { flex-direction: column; align-items: center; }
    .btn-hero-primary, .btn-hero-outline { width: 100%; max-width: 280px; text-align: center; }
    .sobre-accent { display: none; }
    .footer-wrap { flex-direction: column; text-align: center; }
}

/* MENU MOBILE */
@media (max-width: 768px) {
    .navbar-over {
        position: fixed !important;
        padding: 1rem 1.2rem !important;
    }
    .navbar-over ul {
        display: none;
        position: fixed;
        top: 58px; left: 0; right: 0;
        background: rgba(10,8,6,0.99);
        flex-direction: column !important;
        padding: 0.5rem 0;
        border-bottom: 1px solid #1E1814;
        gap: 0 !important;
        z-index: 999;
    }
    .navbar-over ul.mobile-open { display: flex !important; }
    .navbar-over ul li { width: 100%; }
    .navbar-over ul a {
        display: block !important;
        padding: 0.9rem 1.5rem !important;
        border-bottom: 1px solid #141008 !important;
        color: rgba(255,255,255,0.6) !important;
        font-size: 0.82rem !important;
    }
    .navbar-over ul a:hover { color: #C8A951 !important; }
    #hamburger { display: block !important; }
    .hero-main { padding-top: 60px; }
    .hero-name { font-size: clamp(2.5rem, 15vw, 5rem) !important; }
    .sobre-wrap, .contact-wrap { grid-template-columns: 1fr !important; gap: 2rem !important; }
    .destaques-wrap { grid-template-columns: 1fr !important; }
    .hero-btns { flex-direction: column; align-items: center; }
    .btn-hero-primary, .btn-hero-outline { width: 80%; text-align: center; }
    .sobre-accent { display: none; }
    .footer-wrap { flex-direction: column; text-align: center; }
    .f-links { justify-content: center; }
}
</style>
</head>
<body>

<!-- NAVBAR -->
<!-- NAVBAR -->
<!-- NAVBAR -->
<nav class="navbar-over" id="navbar">
    <div class="brand">MUIANGA'S <span>BAR & RESTAURANTE</span></div>
    <ul id="nav-menu">
        <li><a href="#inicio">INÍCIO</a></li>
        <li><a href="${pageContext.request.contextPath}/menu">MENU</a></li>
        <li><a href="${pageContext.request.contextPath}/reserva">RESERVA</a></li>
        <li><a href="#contactos">CONTACTOS</a></li>
        <li><a href="${pageContext.request.contextPath}/delivery"> DELIVERY</a></li>
        <%-- Botão cliente: muda conforme login --%>
        <c:choose>
            <c:when test="${not empty sessionScope.cliente}">
                <li><a href="${pageContext.request.contextPath}/cliente/area" class="btn-nav-area">👤 ${sessionScope.cliente.nome}</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/cliente/login" class="btn-nav-area">ENTRAR</a></li>
            </c:otherwise>
        </c:choose>

    </ul>
    <button id="hamburger" onclick="toggleMenu()" style="
    	display:none;background:transparent;
    	border:1px solid rgba(255,255,255,0.2);
    	color:#fff;padding:0.45rem 0.8rem;
    	border-radius:3px;cursor:pointer;
    	font-size:1.1rem;line-height:1;">
    	☰
	</button>
</nav>

<!-- HERO -->
<section class="hero-main" id="inicio">
    <div class="hero-bg"></div>
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <p class="hero-eyebrow">Chimoio · Manica · Moçambique</p>
        <h1 class="hero-name">MUIANGA<span>'S</span></h1>
        <div class="hero-line"></div>
        <p class="hero-tagline">Bar &amp; Restaurante</p>
        <div class="hero-btns">
            <a href="${pageContext.request.contextPath}/menu" class="btn-hero-primary">Ver Menu</a>
            <a href="${pageContext.request.contextPath}/delivery" class="btn-hero-primary" style="background:#6B4C2A;color:#F0EAE0;">Delivery</a>
            <a href="${pageContext.request.contextPath}/reserva" class="btn-hero-outline">Fazer Reserva</a>
        </div>
    </div>
    <div class="scroll-down">↓ &nbsp; scroll</div>
</section>

<!-- SOBRE NÓS -->
<section class="sobre-sec">
    <div class="sobre-wrap">
        <div class="sobre-foto">
            <%--
                USA: interior.webp (foto do bar com as prateleiras)
                Copia o ficheiro para: webapp/imagens_site/interior.webp
            --%>
            <img src="${pageContext.request.contextPath}/imagens_site/fachada.jpeg" alt="Interior Muianga's">
            <div class="sobre-accent"></div>
            <div class="sobre-bud">★ Desde 2020</div>
        </div>
        <div>
            <p class="secao-rotulo">Sobre Nós</p>
            <h2 class="secao-h2">O ponto de encontro<br>de Chimoio</h2>
            <p class="secao-p">
                O Muianga's combina design contemporâneo com a autenticidade moçambicana.
                Madeira maciça, tijolo à vista e iluminação ambiente criam um espaço único
                para almoços, jantares e momentos especiais.
            </p>
            <p class="secao-p">
                Parceiros oficiais da Budweiser, servimos o melhor da gastronomia local
                num ambiente moderno no coração de Chimoio.
            </p>
            <div class="sobre-nums">
                <div class="num-item">
                    <div class="num-val">10+</div>
                    <div class="num-desc">Mesas</div>
                </div>
                <div class="num-item">
                    <div class="num-val">50+</div>
                    <div class="num-desc">Pratos</div>
                </div>
                <div class="num-item">
                    <div class="num-val">2</div>
                    <div class="num-desc">Zonas</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- DESTAQUES -->
<section class="destaques-sec">
    <div class="sec-header">
        <p class="secao-rotulo" style="justify-content:center;">Experiência</p>
        <h2 class="secao-h2" style="color:#F0EAE0;font-size:2rem;">O que nos distingue</h2>
    </div>
    <div class="destaques-wrap">

        <%--
            DESTAQUE 1 — Usa: interior.webp (foto do bar/bebidas)
            Ficheiro: webapp/imagens_site/interior.webp
        --%>
        <div class="dest-item">
            <img src="${pageContext.request.contextPath}/imagens_site/bebidas.webp" alt="Bebidas Premium">
            <div class="dest-overlay"></div>
            <div class="dest-info">
                <div class="dest-num">01</div>
                <div class="dest-icone">
                    <svg viewBox="0 0 24 24" fill="none" stroke="#C8A951" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="28" height="28"><path d="M8 22H16M12 22V11M5 11H19L17 2H7L5 11Z"/></svg>
                </div>
                <div class="dest-titulo">Bebidas Premium</div>
                <div class="dest-desc">Budweiser oficial · Cocktails · Vinhos</div>
            </div>
        </div>
        
        <%-- DESTAQUE 2 — COMIDA --%>
        <div class="dest-item">
            <img src="${pageContext.request.contextPath}/imagens_site/comida.jpg" alt="Gastronomia">
            <div class="dest-overlay"></div>
            <div class="dest-info">
                <div class="dest-num">02</div>
                <div class="dest-icone">
                    <svg viewBox="0 0 24 24" fill="none" stroke="#C8A951" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="28" height="28"><path d="M3 11L12 2L21 11V20A1 1 0 0120 21H15V16H9V21H4A1 1 0 013 20V11Z"/></svg>
                </div>
                <div class="dest-titulo">Gastronomia Local</div>
                <div class="dest-desc">Sabores autênticos de Moçambique</div>
            </div>
        </div>

        <%--
            DESTAQUE 2 — Usa: ambiente.webp (sala com cadeiras e tijolo)
            Ficheiro: webapp/imagens_site/ambiente.webp
        --%>
        <div class="dest-item">
            <img src="${pageContext.request.contextPath}/imagens_site/ambiente.webp" alt="Zona Lounge">
            <div class="dest-overlay"></div>
            <div class="dest-info">
                <div class="dest-num">03</div>
                <div class="dest-icone">
                    <svg viewBox="0 0 24 24" fill="none" stroke="#C8A951" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="28" height="28"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>
                </div>
                <div class="dest-titulo">Zona Lounge</div>
                <div class="dest-desc">Sofás · Música · Ambiente relaxado</div>
            </div>
        </div>
  </div>
</section>


<!-- AVALIAÇÕES -->
<c:if test="${not empty avaliacoes}">
<section class="aval-sec">
    <div class="sec-header">
        <p class="secao-rotulo" style="justify-content:center;">Clientes</p>
        <h2 class="secao-h2" style="color:#F0EAE0;font-size:2rem;">O que dizem de nós</h2>
    </div>
    <div class="aval-grid">
        <c:forEach var="a" items="${avaliacoes}">
        <div class="aval-card">
            <div class="aval-estrelas">
                <c:forEach begin="1" end="${a.estrelas}">⭐</c:forEach>
            </div>
            <div class="aval-texto">"<c:out value="${a.comentario}"/>"</div>
            <div class="aval-autor">
                <div class="aval-avatar">
                    ${fn:substring(a.clienteNome, 0, 1)}
                </div>
                <div>
                    <div class="aval-nome"><c:out value="${a.clienteNome}"/></div>
                    <div class="aval-data"><fmt:formatDate value="${a.dataAvalia}" pattern="dd/MM/yyyy"/></div>
                </div>
            </div>
        </div>
        </c:forEach>
    </div>
</section>
</c:if>

<!-- CONTACTOS -->
<section class="contact-sec" id="contactos">
    <div class="contact-wrap">
        <div>
            <p class="secao-rotulo">Encontra-nos</p>
            <h2 class="contact-h2">Vem visitar&#8209;nos</h2>
            <p class="contact-p">Estamos em Chimoio, prontos para te receber com o melhor ambiente e gastronomia da região.</p>
            <div class="contact-items">
                <div class="contact-item">
                    
                    <div>
                        <div class="c-label">Morada</div>
                        <div class="c-val">Chimoio, Província de Manica</div>
                    </div>
                </div>
                <div class="contact-item">
                    
                    <div>
                        <div class="c-label">Telefone</div>
                        <div class="c-val">+258 87 316 905</div>
                    </div>
                </div>
                <div class="contact-item">
                  
                    <div>
                        <div class="c-label">E-mail</div>
                        <div class="c-val">info@muiangas.mz</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="horario-box">
            <div class="horario-label">Horário de Funcionamento</div>
            <div class="h-row">
                <span class="h-dia">Segunda — Sexta</span>
                <span class="h-hora">9h — 23h</span>
                <span class="h-open">Aberto</span>
            </div>
            <div class="h-row">
                <span class="h-dia">Sábado</span>
                <span class="h-hora">10h — 23h</span>
                <span class="h-open">Aberto</span>
            </div>
            <div class="h-row">
                <span class="h-dia">Domingo</span>
                <span class="h-hora">10h — 22h</span>
                <span class="h-open">Aberto</span>
            </div>
            <div class="h-action">
                <a href="${pageContext.request.contextPath}/reserva"
                   class="btn-hero-primary" style="display:block;text-align:center;">
                    Reservar Mesa
                </a>
            </div>
        </div>
    </div>
</section>

<!-- FOOTER -->
<footer class="footer-wrap">
    <div class="f-brand">MUIANGA'S</div>
    <div class="f-copy">Bar &amp; Restaurante · Chimoio, Manica, Moçambique · &copy; 2026</div>
    <div class="f-links">
        <a href="${pageContext.request.contextPath}/menu">MENU</a>
        <a href="${pageContext.request.contextPath}/reserva">RESERVA</a>

    </div>
    <!-- ponto secreto invisível no footer — duplo clique abre admin -->
    <span id="admin-secret" ondblclick="window.location.href='${pageContext.request.contextPath}/login'"
          style="position:absolute;width:10px;height:10px;opacity:0;cursor:default;"></span>
</footer>

<script>
    // ── ACESSO ADMIN SECRETO: Ctrl+Shift+A ────────────
    document.addEventListener('keydown', function(e) {
        if (e.ctrlKey && e.shiftKey && e.key === 'A') {
            window.location.href = '${pageContext.request.contextPath}/login';
        }
    });
</script>

<script>
    // ── NAVBAR SCROLL ──────────────────────────────────
    const nav = document.getElementById('navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 80) {
            nav.style.background = 'rgba(10,8,6,0.97)';
            nav.style.borderBottom = '1px solid #1E1A14';
            nav.style.backdropFilter = 'blur(14px)';
            nav.style.padding = '1rem 2.5rem';
        } else {
            nav.style.background = 'transparent';
            nav.style.borderBottom = 'none';
            nav.style.backdropFilter = 'none';
            nav.style.padding = '1.8rem 2.5rem';
        }
    });

    // ── MENU HAMBÚRGUER MOBILE ─────────────────────────
    function toggleMenu() {
        const menu = document.getElementById('nav-menu');
        const btn  = document.getElementById('hamburger');
        const open = menu.classList.toggle('mobile-open');
        btn.textContent = open ? '✕' : '☰';
    }

    // Fechar menu ao clicar num link
    document.querySelectorAll('#nav-menu a').forEach(a => {
        a.addEventListener('click', () => {
            document.getElementById('nav-menu').classList.remove('mobile-open');
            document.getElementById('hamburger').textContent = '☰';
        });
    });

    // Mostrar/esconder hambúrguer conforme tamanho do ecrã
    function checkMobile() {
        const btn = document.getElementById('hamburger');
        if (window.innerWidth <= 768) {
            btn.style.display = 'block';
        } else {
            btn.style.display = 'none';
            document.getElementById('nav-menu').classList.remove('mobile-open');
        }
    }
    window.addEventListener('resize', checkMobile);
    checkMobile();
</script>
</body>
</html>

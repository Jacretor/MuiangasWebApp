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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Montserrat:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        :root {
            --gold:    #C8A951;
            --wood:    #6B4C2A;
            --dark:    #0A0806;
            --dark2:   #120F0C;
            --dark3:   #1A1410;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }
        body { font-family: 'Montserrat', sans-serif; background: var(--dark); color: #F0EAE0; overflow-x: hidden; }

        /* ══ NAVBAR ══════════════════════════════════════════ */
        .nav {
            position: fixed; top: 0; left: 0; right: 0; z-index: 1000;
            display: flex; align-items: center; justify-content: space-between;
            padding: 1.5rem 3rem;
            transition: all 0.4s ease;
        }
        .nav.scrolled {
            background: rgba(10,8,6,0.96);
            border-bottom: 1px solid rgba(200,169,81,0.15);
            backdrop-filter: blur(20px);
            padding: 1rem 3rem;
        }
        .nav-brand {
            font-family: 'Playfair Display', serif;
            font-size: 1.4rem; font-weight: 900;
            letter-spacing: 3px; color: #fff;
        }
        .nav-brand span { color: var(--gold); }
        .nav-links { display: flex; align-items: center; gap: 2.5rem; }
        .nav-links a {
            font-size: 0.68rem; font-weight: 600;
            letter-spacing: 2.5px; text-transform: uppercase;
            color: rgba(255,255,255,0.6); text-decoration: none;
            transition: color 0.2s; position: relative;
        }
        .nav-links a::after {
            content: ''; position: absolute; bottom: -4px; left: 0; right: 0;
            height: 1px; background: var(--gold);
            transform: scaleX(0); transition: transform 0.2s;
        }
        .nav-links a:hover { color: var(--gold); }
        .nav-links a:hover::after { transform: scaleX(1); }
        .nav-cta {
            padding: 0.55rem 1.4rem; border-radius: 50px;
            border: 1.5px solid var(--gold); color: var(--gold) !important;
            font-weight: 700 !important; transition: all 0.25s !important;
        }
        .nav-cta:hover { background: var(--gold) !important; color: var(--dark) !important; }
        .nav-cta::after { display: none !important; }
        .hamburger {
            display: none; flex-direction: column; gap: 5px;
            cursor: pointer; background: none; border: none; padding: 4px;
        }
        .hamburger span {
            display: block; width: 24px; height: 2px;
            background: #fff; border-radius: 2px; transition: all 0.3s;
        }

        /* ══ HERO ════════════════════════════════════════════ */
        .hero {
            position: relative; min-height: 100vh;
            display: flex; align-items: center; justify-content: center;
            overflow: hidden;
        }
        .hero-bg {
            position: absolute; inset: 0;
            background-image: url('${pageContext.request.contextPath}/imagens_site/fachada.jpeg');
            background-size: cover; background-position: center 30%;
            filter: brightness(0.25) saturate(0.8);
            transform: scale(1.06);
            animation: heroZoom 18s ease-in-out infinite alternate;
        }
        @keyframes heroZoom {
            from { transform: scale(1.06); }
            to   { transform: scale(1.12); }
        }
        .hero-gradient {
            position: absolute; inset: 0;
            background:
                linear-gradient(180deg, rgba(10,8,6,0.4) 0%, transparent 30%,
                    transparent 50%, rgba(10,8,6,0.85) 80%, rgba(10,8,6,1) 100%),
                linear-gradient(90deg, rgba(10,8,6,0.6) 0%, transparent 50%);
        }
        .hero-content {
            position: relative; z-index: 2;
            max-width: 800px; padding: 0 2rem;
            text-align: center;
        }
        .hero-tag {
            display: inline-flex; align-items: center; gap: 0.8rem;
            font-size: 0.62rem; letter-spacing: 5px; text-transform: uppercase;
            color: var(--gold); margin-bottom: 2rem; opacity: 0.9;
        }
        .hero-tag::before, .hero-tag::after {
            content: ''; width: 30px; height: 1px; background: var(--gold);
        }
        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(4rem, 13vw, 9rem);
            font-weight: 900; line-height: 0.9;
            color: #fff; letter-spacing: 4px;
            text-shadow: 0 8px 60px rgba(0,0,0,0.8);
            margin-bottom: 0.2rem;
        }
        .hero-title em { color: var(--gold); font-style: normal; }
        .hero-sub {
            font-size: 0.72rem; letter-spacing: 6px; text-transform: uppercase;
            color: rgba(255,255,255,0.4); margin: 1.5rem 0 2.5rem;
        }
        .hero-divider {
            width: 80px; height: 1px;
            background: linear-gradient(90deg, transparent, var(--gold), transparent);
            margin: 0 auto 2.5rem;
        }
        .hero-btns { display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap; }
        .btn-primary {
            padding: 0.9rem 2.4rem; border-radius: 50px;
            border: 1.5px solid var(--gold); color: var(--gold);
            font-family: 'Montserrat', sans-serif;
            font-size: 0.72rem; font-weight: 700; letter-spacing: 2px;
            text-transform: uppercase; text-decoration: none;
            transition: all 0.25s; background: transparent;
        }
        .btn-primary:hover {
            background: var(--gold); color: var(--dark);
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(200,169,81,0.35);
        }
        .btn-secondary {
            padding: 0.9rem 2.4rem; border-radius: 50px;
            border: 1.5px solid rgba(255,255,255,0.2);
            color: rgba(255,255,255,0.7);
            font-family: 'Montserrat', sans-serif;
            font-size: 0.72rem; font-weight: 600; letter-spacing: 2px;
            text-transform: uppercase; text-decoration: none;
            transition: all 0.25s; background: transparent;
        }
        .btn-secondary:hover { border-color: var(--gold); color: var(--gold); }

        /* Scroll indicator */
        .scroll-indicator {
            position: absolute; bottom: 2.5rem; left: 50%;
            transform: translateX(-50%); z-index: 2;
            display: flex; flex-direction: column; align-items: center; gap: 0.5rem;
        }
        .scroll-line {
            width: 1px; height: 50px;
            background: linear-gradient(180deg, var(--gold), transparent);
            animation: scrollAnim 1.8s ease-in-out infinite;
        }
        @keyframes scrollAnim {
            0%   { transform: scaleY(0); transform-origin: top; }
            50%  { transform: scaleY(1); transform-origin: top; }
            51%  { transform: scaleY(1); transform-origin: bottom; }
            100% { transform: scaleY(0); transform-origin: bottom; }
        }
        .scroll-label {
            font-size: 0.55rem; letter-spacing: 4px; text-transform: uppercase;
            color: rgba(255,255,255,0.3);
        }

        /* ══ STATS FLUTUANTES ════════════════════════════════ */
        .hero-stats {
            position: absolute; bottom: 0; left: 0; right: 0; z-index: 3;
            display: flex; justify-content: center; gap: 0;
        }
        .hero-stat {
            padding: 1.4rem 3rem; text-align: center;
            border-top: 1px solid rgba(200,169,81,0.2);
            border-right: 1px solid rgba(200,169,81,0.1);
            background: rgba(10,8,6,0.7); backdrop-filter: blur(10px);
        }
        .hero-stat:last-child { border-right: none; }
        .hero-stat-num {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem; font-weight: 700; color: var(--gold); line-height: 1;
        }
        .hero-stat-lbl {
            font-size: 0.55rem; letter-spacing: 3px; text-transform: uppercase;
            color: rgba(255,255,255,0.35); margin-top: 0.3rem;
        }

        /* ══ SECÇÃO MENU EM DESTAQUE ═════════════════════════ */
        .menu-preview {
            background: var(--dark2); padding: 7rem 2rem;
        }
        .sec-label {
            display: flex; align-items: center; gap: 1rem;
            font-size: 0.6rem; letter-spacing: 5px; text-transform: uppercase;
            color: var(--gold); margin-bottom: 1rem;
        }
        .sec-label::before { content: ''; width: 40px; height: 1px; background: var(--gold); }
        .sec-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(2rem, 4vw, 3.2rem);
            font-weight: 700; color: #F0EAE0; line-height: 1.2;
            margin-bottom: 1rem;
        }
        .sec-desc {
            font-size: 0.88rem; color: #5A4E44;
            line-height: 1.9; max-width: 500px; margin-bottom: 2.5rem;
        }
        .menu-header { max-width: 1100px; margin: 0 auto; display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 3rem; flex-wrap: wrap; gap: 1.5rem; }
        .pratos-grid {
            max-width: 1100px; margin: 0 auto;
            display: grid; grid-template-columns: repeat(3, 1fr);
            gap: 1.5px; background: rgba(200,169,81,0.08);
        }
        .prato-item {
            position: relative; overflow: hidden;
            aspect-ratio: 4/3; cursor: pointer;
            background: var(--dark3);
        }
        .prato-item img {
            width: 100%; height: 100%; object-fit: cover;
            transition: transform 0.6s ease, filter 0.4s ease;
            filter: brightness(0.65) saturate(0.9);
        }
        .prato-item:hover img { transform: scale(1.08); filter: brightness(0.5) saturate(0.7); }
        .prato-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(10,8,6,0.95) 0%, transparent 60%);
        }
        .prato-info {
            position: absolute; bottom: 0; left: 0; right: 0;
            padding: 1.5rem;
            transform: translateY(10px); transition: transform 0.3s;
        }
        .prato-item:hover .prato-info { transform: translateY(0); }
        .prato-cat { font-size: 0.55rem; letter-spacing: 3px; text-transform: uppercase; color: var(--gold); margin-bottom: 0.3rem; }
        .prato-nome { font-size: 1rem; font-weight: 700; color: #fff; margin-bottom: 0.3rem; }
        .prato-desc { font-size: 0.72rem; color: rgba(255,255,255,0.5); margin-bottom: 0.6rem; }
        .prato-preco { font-size: 1rem; font-weight: 900; color: var(--gold); }
        /* Item grande */
        .prato-item.grande { grid-row: span 2; aspect-ratio: auto; }
        .prato-item.grande img { height: 100%; }

        /* ══ EXPERIÊNCIA (3 colunas) ═════════════════════════ */
        .exp-sec { background: var(--dark); padding: 7rem 2rem; }
        .exp-grid {
            max-width: 1100px; margin: 3rem auto 0;
            display: grid; grid-template-columns: repeat(3,1fr); gap: 2px;
            background: rgba(200,169,81,0.06);
        }
        .exp-item {
            position: relative; overflow: hidden; cursor: pointer;
            min-height: 420px;
        }
        .exp-item img {
            width: 100%; height: 100%; object-fit: cover;
            transition: transform 0.7s ease, filter 0.4s;
            filter: brightness(0.55) saturate(0.8);
            position: absolute; inset: 0;
        }
        .exp-item:hover img { transform: scale(1.06); filter: brightness(0.35); }
        .exp-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(10,8,6,0.98) 0%, rgba(10,8,6,0.2) 60%);
        }
        .exp-content {
            position: absolute; bottom: 0; left: 0; right: 0;
            padding: 2rem 1.8rem;
        }
        .exp-num { font-size: 0.55rem; letter-spacing: 4px; color: var(--gold); margin-bottom: 0.8rem; text-transform: uppercase; }
        .exp-icone { margin-bottom: 0.8rem; }
        .exp-titulo { font-size: 1.1rem; font-weight: 800; color: #fff; margin-bottom: 0.4rem; }
        .exp-desc { font-size: 0.75rem; color: rgba(255,255,255,0.45); line-height: 1.6; }
        .exp-cta {
            display: inline-block; margin-top: 1rem;
            font-size: 0.62rem; letter-spacing: 2px; text-transform: uppercase;
            color: var(--gold); text-decoration: none;
            border-bottom: 1px solid rgba(200,169,81,0.3);
            padding-bottom: 2px; transition: border-color 0.2s;
            opacity: 0; transform: translateY(5px); transition: all 0.3s;
        }
        .exp-item:hover .exp-cta { opacity: 1; transform: translateY(0); }

        /* ══ SOBRE ════════════════════════════════════════════ */
        .sobre-sec { background: var(--dark2); padding: 7rem 2rem; }
        .sobre-inner {
            max-width: 1100px; margin: 0 auto;
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 6rem; align-items: center;
        }
        .sobre-imgs {
            position: relative; display: grid;
            grid-template-columns: 1fr 1fr; grid-template-rows: auto auto;
            gap: 8px;
        }
        .sobre-img-main {
            grid-column: 1 / -1;
            height: 300px; overflow: hidden; border-radius: 4px;
        }
        .sobre-img-main img { width: 100%; height: 100%; object-fit: cover; filter: brightness(0.85); }
        .sobre-img-sm { height: 160px; overflow: hidden; border-radius: 4px; }
        .sobre-img-sm img { width: 100%; height: 100%; object-fit: cover; filter: brightness(0.8); }
        .sobre-badge {
            position: absolute; bottom: -15px; right: -15px;
            width: 100px; height: 100px; border-radius: 50%;
            background: var(--gold); color: var(--dark);
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            font-family: 'Playfair Display', serif;
            box-shadow: 0 8px 30px rgba(200,169,81,0.4);
            z-index: 2;
        }
        .sobre-badge-num { font-size: 1.8rem; font-weight: 700; line-height: 1; }
        .sobre-badge-txt { font-size: 0.55rem; letter-spacing: 1px; text-transform: uppercase; font-family: 'Montserrat', sans-serif; }
        .sobre-nums {
            display: grid; grid-template-columns: repeat(3,1fr);
            gap: 1rem; margin-top: 2.5rem; padding-top: 2rem;
            border-top: 1px solid rgba(200,169,81,0.15);
        }
        .num-val { font-family: 'Playfair Display', serif; font-size: 2.2rem; font-weight: 700; color: var(--gold); line-height: 1; }
        .num-lbl { font-size: 0.58rem; letter-spacing: 2px; text-transform: uppercase; color: #3A3028; margin-top: 0.3rem; }

        /* ══ AVALIAÇÕES ═══════════════════════════════════════ */
        .aval-sec { background: var(--dark); padding: 7rem 2rem; }
        .aval-grid {
            max-width: 1100px; margin: 3rem auto 0;
            display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
        }
        .aval-card {
            background: var(--dark2); border: 1px solid rgba(200,169,81,0.1);
            border-radius: 12px; padding: 1.8rem;
            transition: border-color 0.3s, transform 0.3s;
        }
        .aval-card:hover { border-color: rgba(200,169,81,0.3); transform: translateY(-4px); }
        .aval-estrelas { display: flex; gap: 3px; margin-bottom: 1rem; }
        .aval-estrelas svg path { stroke-width: 1.5; }
        .aval-texto {
            font-size: 0.9rem; color: #8A7E72; line-height: 1.8;
            font-style: italic; margin-bottom: 1.5rem;
            font-family: 'Playfair Display', serif;
        }
        .aval-autor { display: flex; align-items: center; gap: 0.8rem; }
        .aval-avatar {
            width: 40px; height: 40px; border-radius: 50%;
            background: linear-gradient(135deg, var(--wood), var(--gold));
            display: flex; align-items: center; justify-content: center;
            font-weight: 900; color: var(--dark); font-size: 0.9rem; flex-shrink: 0;
        }
        .aval-nome { font-size: 0.8rem; font-weight: 700; color: #C0B4A8; }
        .aval-data { font-size: 0.62rem; color: #3A3028; margin-top: 0.15rem; }

        /* ══ CONTACTOS ════════════════════════════════════════ */
        .contact-sec { background: var(--dark2); padding: 7rem 2rem; }
        .contact-inner {
            max-width: 1100px; margin: 0 auto;
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 6rem; align-items: start;
        }
        .contact-h { font-family: 'Playfair Display', serif; font-size: 2.5rem; font-weight: 700; color: #F0EAE0; margin-bottom: 0.5rem; }
        .contact-p { color: #4A4038; font-size: 0.88rem; line-height: 1.9; margin-bottom: 2.5rem; }
        .contact-list { display: flex; flex-direction: column; gap: 0; }
        .contact-row {
            display: flex; align-items: center; gap: 1.2rem;
            padding: 1.1rem 0; border-bottom: 1px solid #161210;
        }
        .contact-row:last-child { border-bottom: none; }
        .contact-icon {
            width: 44px; height: 44px; border-radius: 10px; flex-shrink: 0;
            background: rgba(200,169,81,0.07); border: 1px solid rgba(200,169,81,0.15);
            display: flex; align-items: center; justify-content: center;
        }
        .contact-icon svg { width: 18px; height: 18px; stroke: var(--gold); fill: none; stroke-width: 1.8; stroke-linecap: round; stroke-linejoin: round; }
        .c-lbl { font-size: 0.58rem; text-transform: uppercase; letter-spacing: 2px; color: #3A3028; }
        .c-val { font-size: 0.9rem; color: #B8ACA0; font-weight: 600; margin-top: 0.15rem; }

        .horario-box {
            background: rgba(200,169,81,0.04); border: 1px solid rgba(200,169,81,0.15);
            border-radius: 12px; padding: 2.2rem;
        }
        .horario-titulo {
            font-size: 0.58rem; letter-spacing: 4px; text-transform: uppercase;
            color: var(--gold); margin-bottom: 2rem;
        }
        .h-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 0.85rem 0; border-bottom: 1px solid rgba(255,255,255,0.04);
            font-size: 0.82rem;
        }
        .h-row:last-of-type { border-bottom: none; margin-bottom: 1.5rem; }
        .h-dia  { color: #4A4038; }
        .h-hora { color: #C0B4A8; font-weight: 700; }
        .h-open { font-size: 0.58rem; letter-spacing: 2px; text-transform: uppercase; color: #5A8A5A; }

        /* ══ FOOTER ═══════════════════════════════════════════ */
        .footer {
            background: #060504; border-top: 1px solid rgba(200,169,81,0.08);
            padding: 3rem 2.5rem 2rem;
        }
        .footer-inner {
            max-width: 1100px; margin: 0 auto;
            display: grid; grid-template-columns: 1fr 1fr 1fr;
            gap: 3rem; padding-bottom: 2rem;
            border-bottom: 1px solid rgba(255,255,255,0.04);
        }
        .footer-brand-name {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem; font-weight: 700; color: var(--gold);
            letter-spacing: 3px; margin-bottom: 0.5rem;
        }
        .footer-brand-sub { font-size: 0.65rem; color: #2A2218; letter-spacing: 3px; text-transform: uppercase; }
        .footer-brand-desc { font-size: 0.78rem; color: #2A2218; line-height: 1.8; margin-top: 1rem; max-width: 200px; }
        .footer-col-title { font-size: 0.6rem; letter-spacing: 3px; text-transform: uppercase; color: var(--gold); margin-bottom: 1.2rem; }
        .footer-links { display: flex; flex-direction: column; gap: 0.6rem; }
        .footer-links a { font-size: 0.75rem; color: #2A2218; text-decoration: none; transition: color 0.2s; }
        .footer-links a:hover { color: var(--gold); }
        .footer-bottom {
            max-width: 1100px; margin: 1.5rem auto 0;
            display: flex; justify-content: space-between; align-items: center;
            flex-wrap: wrap; gap: 1rem;
        }
        .footer-copy { font-size: 0.65rem; color: #1A1410; }

        /* ══ RESPONSIVE ═══════════════════════════════════════ */
        @media (max-width: 768px) {
            .nav { padding: 1.2rem 1.5rem; }
            .nav.scrolled { padding: 0.9rem 1.5rem; }
            .nav-links { display: none; }
            .nav-links.open {
                display: flex; flex-direction: column;
                position: fixed; top: 60px; left: 0; right: 0;
                background: rgba(10,8,6,0.98);
                padding: 1.5rem; gap: 0;
                border-bottom: 1px solid rgba(200,169,81,0.1);
                z-index: 999;
            }
            .nav-links.open a { padding: 1rem 0; border-bottom: 1px solid #0E0C0A; font-size: 0.8rem; }
            .hamburger { display: flex; }
            .hero-title { font-size: clamp(3rem, 16vw, 5.5rem); }
            .hero-stats { display: none; }
            .pratos-grid { grid-template-columns: 1fr 1fr; }
            .prato-item.grande { grid-row: span 1; }
            .exp-grid, .sobre-inner, .contact-inner { grid-template-columns: 1fr; gap: 3rem; }
            .sobre-badge { display: none; }
            .footer-inner { grid-template-columns: 1fr; gap: 2rem; }
            .footer-bottom { flex-direction: column; text-align: center; }
            .hero-btns { flex-direction: column; align-items: center; }
            .btn-primary, .btn-secondary { width: 240px; text-align: center; }
        }
        @media (max-width: 480px) {
            .pratos-grid { grid-template-columns: 1fr; }
            .sobre-imgs { grid-template-columns: 1fr; }
            .sobre-img-sm { display: none; }
        }
    </style>
</head>
<body>

<!-- ══ NAVBAR ══════════════════════════════════════════════ -->
<nav class="nav" id="navbar">
    <div class="nav-brand">MUIANGA<em style="color:var(--gold);font-style:normal;">'S</em></div>
    <div class="nav-links" id="navLinks">
        <a href="#inicio">Início</a>
        <a href="#menu">Menu</a>
        <a href="${pageContext.request.contextPath}/reserva">Reserva</a>
        <a href="${pageContext.request.contextPath}/delivery">Delivery</a>
        <a href="#contactos">Contactos</a>
        <c:choose>
            <c:when test="${not empty sessionScope.cliente}">
                <a href="${pageContext.request.contextPath}/cliente/area" class="nav-cta">
                    ${sessionScope.cliente.nome}
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/cliente/login" class="nav-cta">Entrar</a>
            </c:otherwise>
        </c:choose>
    </div>
    <button class="hamburger" id="hamburger" onclick="toggleNav()" aria-label="Menu">
        <span></span><span></span><span></span>
    </button>
</nav>

<!-- ══ HERO ════════════════════════════════════════════════ -->
<section class="hero" id="inicio">
    <div class="hero-bg"></div>
    <div class="hero-gradient"></div>
    <div class="hero-content">
        <div class="hero-tag">Chimoio · Manica · Moçambique</div>
        <h1 class="hero-title">MUIANGA<em>'S</em></h1>
        <div class="hero-divider"></div>
        <p class="hero-sub">Bar &amp; Restaurante · Desde 2020</p>
        <div class="hero-btns">
            <a href="${pageContext.request.contextPath}/menu" class="btn-primary">Ver Menu</a>
            <a href="${pageContext.request.contextPath}/delivery" class="btn-primary" style="border-color:var(--wood);color:#C0A880;">Delivery</a>
            <a href="${pageContext.request.contextPath}/reserva" class="btn-secondary">Reservar Mesa</a>
        </div>
    </div>
    <div class="scroll-indicator">
        <div class="scroll-line"></div>
        <span class="scroll-label">Scroll</span>
    </div>
    <div class="hero-stats">
        <div class="hero-stat">
            <div class="hero-stat-num">10+</div>
            <div class="hero-stat-lbl">Mesas</div>
        </div>
        <div class="hero-stat">
            <div class="hero-stat-num">50+</div>
            <div class="hero-stat-lbl">Pratos</div>
        </div>
        <div class="hero-stat">
            <div class="hero-stat-num">5★</div>
            <div class="hero-stat-lbl">Avaliação</div>
        </div>
        <div class="hero-stat">
            <div class="hero-stat-num">2020</div>
            <div class="hero-stat-lbl">Fundado</div>
        </div>
    </div>
</section>

<!-- ══ MENU EM DESTAQUE ════════════════════════════════════ -->
<section class="menu-preview" id="menu">
    <div class="menu-header">
        <div>
            <div class="sec-label">Gastronomia</div>
            <h2 class="sec-title">Os nossos pratos<br>em destaque</h2>
            <p class="sec-desc">Sabores autênticos de Moçambique preparados com ingredientes frescos e receitas tradicionais.</p>
        </div>
        <a href="${pageContext.request.contextPath}/menu" class="btn-primary" style="white-space:nowrap;">Ver Menu Completo</a>
    </div>
    <div class="pratos-grid">
        <%-- Item grande --%>
        <div class="prato-item grande">
            <img src="${pageContext.request.contextPath}/imagens_site/comida.jpg" alt="Prato principal">
            <div class="prato-overlay"></div>
            <div class="prato-info">
                <div class="prato-cat">Refeições</div>
                <div class="prato-nome">Gastronomia Moçambicana</div>
                <div class="prato-desc">Sabores autênticos do coração de Moçambique</div>
                <a href="${pageContext.request.contextPath}/menu" style="display:inline-block;margin-top:0.8rem;font-size:0.62rem;letter-spacing:2px;text-transform:uppercase;color:var(--gold);text-decoration:none;border-bottom:1px solid rgba(200,169,81,0.4);padding-bottom:2px;">Ver menu →</a>
            </div>
        </div>
        <%-- Item bebidas --%>
        <div class="prato-item">
            <img src="${pageContext.request.contextPath}/imagens_site/bebidas.webp" alt="Bebidas">
            <div class="prato-overlay"></div>
            <div class="prato-info">
                <div class="prato-cat">Bebidas</div>
                <div class="prato-nome">Bebidas Premium</div>
                <div class="prato-desc">Budweiser oficial · Cocktails · Vinhos selecionados</div>
            </div>
        </div>
        <%-- Item ambiente --%>
        <div class="prato-item">
            <img src="${pageContext.request.contextPath}/imagens_site/ambiente.webp" alt="Ambiente">
            <div class="prato-overlay"></div>
            <div class="prato-info">
                <div class="prato-cat">Espaço</div>
                <div class="prato-nome">Zona Lounge</div>
                <div class="prato-desc">Sofás · Música ambiente · Espaço relaxado</div>
            </div>
        </div>
    </div>
</section>

<!-- ══ EXPERIÊNCIA ═════════════════════════════════════════ -->
<section class="exp-sec">
    <div style="max-width:1100px;margin:0 auto;">
        <div class="sec-label">Experiência</div>
        <h2 class="sec-title">O que nos torna únicos</h2>
    </div>
    <div class="exp-grid">
        <div class="exp-item">
            <img src="${pageContext.request.contextPath}/imagens_site/bebidas.webp" alt="Bebidas">
            <div class="exp-overlay"></div>
            <div class="exp-content">
                <div class="exp-num">01</div>
                <div class="exp-icone">
                    <svg viewBox="0 0 24 24" fill="none" stroke="#C8A951" stroke-width="1.5" stroke-linecap="round" width="26" height="26"><path d="M8 22H16M12 22V11M5 11H19L17 2H7L5 11Z"/></svg>
                </div>
                <div class="exp-titulo">Bebidas Premium</div>
                <div class="exp-desc">Parceiros Budweiser. Cocktails artesanais e vinhos seleccionados.</div>
                <a href="${pageContext.request.contextPath}/menu" class="exp-cta">Explorar →</a>
            </div>
        </div>
        <div class="exp-item">
            <img src="${pageContext.request.contextPath}/imagens_site/comida.jpg" alt="Gastronomia">
            <div class="exp-overlay"></div>
            <div class="exp-content">
                <div class="exp-num">02</div>
                <div class="exp-icone">
                    <svg viewBox="0 0 24 24" fill="none" stroke="#C8A951" stroke-width="1.5" stroke-linecap="round" width="26" height="26"><path d="M18 8h1a4 4 0 010 8h-1M2 8h16v9a4 4 0 01-4 4H6a4 4 0 01-4-4V8z"/><line x1="6" y1="1" x2="6" y2="4"/><line x1="10" y1="1" x2="10" y2="4"/><line x1="14" y1="1" x2="14" y2="4"/></svg>
                </div>
                <div class="exp-titulo">Gastronomia Local</div>
                <div class="exp-desc">Ingredientes frescos. Receitas tradicionais de Moçambique.</div>
                <a href="${pageContext.request.contextPath}/menu" class="exp-cta">Ver pratos →</a>
            </div>
        </div>
        <div class="exp-item">
            <img src="${pageContext.request.contextPath}/imagens_site/ambiente.webp" alt="Ambiente">
            <div class="exp-overlay"></div>
            <div class="exp-content">
                <div class="exp-num">03</div>
                <div class="exp-icone">
                    <svg viewBox="0 0 24 24" fill="none" stroke="#C8A951" stroke-width="1.5" stroke-linecap="round" width="26" height="26"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                </div>
                <div class="exp-titulo">Ambiente Único</div>
                <div class="exp-desc">Madeira, tijolo à vista e iluminação quente. Espaço pensado para momentos especiais.</div>
                <a href="${pageContext.request.contextPath}/reserva" class="exp-cta">Reservar →</a>
            </div>
        </div>
    </div>
</section>

<!-- ══ SOBRE NÓS ═══════════════════════════════════════════ -->
<section class="sobre-sec">
    <div class="sobre-inner">
        <div class="sobre-imgs">
            <div class="sobre-img-main">
                <img src="${pageContext.request.contextPath}/imagens_site/fachada.jpeg" alt="Muianga's Fachada">
            </div>
            <div class="sobre-img-sm">
                <img src="${pageContext.request.contextPath}/imagens_site/comida.jpg" alt="Pratos">
            </div>
            <div class="sobre-img-sm">
                <img src="${pageContext.request.contextPath}/imagens_site/bebidas.webp" alt="Bebidas">
            </div>
            <div class="sobre-badge">
                <div class="sobre-badge-num">5</div>
                <div class="sobre-badge-txt">Anos</div>
            </div>
        </div>
        <div>
            <div class="sec-label">Sobre Nós</div>
            <h2 class="sec-title">O ponto de encontro<br>de Chimoio</h2>
            <p class="sec-desc">O Muianga's combina design contemporâneo com a autenticidade moçambicana. Madeira maciça, tijolo à vista e iluminação ambiente criam um espaço único para almoços, jantares e momentos especiais.</p>
            <p class="sec-desc">Parceiros oficiais da Budweiser, servimos o melhor da gastronomia local num ambiente moderno no coração de Chimoio. Desde 2020 a criar memórias.</p>
            <div class="sobre-nums">
                <div>
                    <div class="num-val">10+</div>
                    <div class="num-lbl">Mesas</div>
                </div>
                <div>
                    <div class="num-val">50+</div>
                    <div class="num-lbl">Pratos</div>
                </div>
                <div>
                    <div class="num-val">5★</div>
                    <div class="num-lbl">Avaliação</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══ AVALIAÇÕES ══════════════════════════════════════════ -->
<c:if test="${not empty avaliacoes}">
<section class="aval-sec">
    <div style="max-width:1100px;margin:0 auto;">
        <div class="sec-label">Clientes</div>
        <h2 class="sec-title">O que dizem de nós</h2>
    </div>
    <div class="aval-grid">
        <c:forEach var="a" items="${avaliacoes}">
        <div class="aval-card">
            <div class="aval-estrelas">
                <c:forEach begin="1" end="5" var="i">
                    <svg class="estrela-svg" viewBox="0 0 24 24" width="16" height="16">
                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"
                              fill="${i <= a.estrelas ? '#C8A951' : 'none'}"
                              stroke="#C8A951" stroke-width="1.5"/>
                    </svg>
                </c:forEach>
            </div>
            <div class="aval-texto">"<c:out value="${a.comentario}"/>"</div>
            <div class="aval-autor">
                <div class="aval-avatar">${fn:substring(a.clienteNome, 0, 1)}</div>
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

<!-- ══ CONTACTOS ═══════════════════════════════════════════ -->
<section class="contact-sec" id="contactos">
    <div class="contact-inner">
        <div>
            <div class="sec-label">Encontra-nos</div>
            <h2 class="contact-h">Vem visitar&#8209;nos</h2>
            <p class="contact-p">Estamos em Chimoio, prontos para te receber com o melhor ambiente e gastronomia da região.</p>
            <div class="contact-list">
                <div class="contact-row">
                    <div class="contact-icon">
                        <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
                    </div>
                    <div>
                        <div class="c-lbl">Morada</div>
                        <div class="c-val">Chimoio, Província de Manica</div>
                    </div>
                </div>
                <div class="contact-row">
                    <div class="contact-icon">
                        <svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 013.07 9.81a19.79 19.79 0 01-3.07-8.68A2 2 0 012 .18h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L6.09 7.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z"/></svg>
                    </div>
                    <div>
                        <div class="c-lbl">Telefone</div>
                        <div class="c-val">+258 87 316 905</div>
                    </div>
                </div>
                <div class="contact-row">
                    <div class="contact-icon">
                        <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                    </div>
                    <div>
                        <div class="c-lbl">E-mail</div>
                        <div class="c-val">info@muiangas.mz</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="horario-box">
            <div class="horario-titulo">Horário de Funcionamento</div>
            <div class="h-row"><span class="h-dia">Segunda — Sexta</span><span class="h-hora">9h — 23h</span><span class="h-open">Aberto</span></div>
            <div class="h-row"><span class="h-dia">Sábado</span><span class="h-hora">10h — 23h</span><span class="h-open">Aberto</span></div>
            <div class="h-row"><span class="h-dia">Domingo</span><span class="h-hora">10h — 22h</span><span class="h-open">Aberto</span></div>
            <a href="${pageContext.request.contextPath}/reserva" class="btn-primary" style="display:block;text-align:center;margin-top:1.5rem;">
                Reservar Mesa
            </a>
        </div>
    </div>
</section>

<!-- ══ FOOTER ══════════════════════════════════════════════ -->
<footer class="footer">
    <div class="footer-inner">
        <div>
            <div class="footer-brand-name">MUIANGA'S</div>
            <div class="footer-brand-sub">Bar &amp; Restaurante</div>
            <div class="footer-brand-desc">O ponto de encontro de Chimoio desde 2020. Gastronomia, ambiente e boa música.</div>
        </div>
        <div>
            <div class="footer-col-title">Navegação</div>
            <div class="footer-links">
                <a href="${pageContext.request.contextPath}/menu">Menu Digital</a>
                <a href="${pageContext.request.contextPath}/delivery">Delivery</a>
                <a href="${pageContext.request.contextPath}/reserva">Reservar Mesa</a>
                <a href="${pageContext.request.contextPath}/cliente/login">Minha Conta</a>
            </div>
        </div>
        <div>
            <div class="footer-col-title">Contacto</div>
            <div class="footer-links">
                <a href="#">+258 87 316 905</a>
                <a href="#">info@muiangas.mz</a>
                <a href="#">Chimoio, Manica</a>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <div class="footer-copy">© 2026 Muianga's Bar &amp; Restaurante · Chimoio, Moçambique</div>
    </div>
    <span id="admin-secret" ondblclick="window.location.href='${pageContext.request.contextPath}/login'"
          style="position:absolute;width:10px;height:10px;opacity:0;cursor:default;"></span>
</footer>

<script>
// Navbar scroll
const nav = document.getElementById('navbar');
window.addEventListener('scroll', () => {
    nav.classList.toggle('scrolled', window.scrollY > 60);
});

// Mobile nav
function toggleNav() {
    const links = document.getElementById('navLinks');
    const btn   = document.getElementById('hamburger');
    const open  = links.classList.toggle('open');
    btn.setAttribute('aria-expanded', open);
}
document.querySelectorAll('#navLinks a').forEach(a => {
    a.addEventListener('click', () => {
        document.getElementById('navLinks').classList.remove('open');
    });
});

// Smooth scroll
document.querySelectorAll('a[href^="#"]').forEach(a => {
    a.addEventListener('click', e => {
        const target = document.querySelector(a.getAttribute('href'));
        if (target) { e.preventDefault(); target.scrollIntoView({ behavior: 'smooth' }); }
    });
});

// Admin secret — Ctrl+Alt+M
// Admin secret — Ctrl+Shift+A
document.addEventListener('keydown', e => {
    // Verificamos se Ctrl e Shift estão pressionados e se a tecla é 'a' ou 'A'
    if (e.ctrlKey && e.shiftKey && (e.key === 'a' || e.key === 'A' || e.keyCode === 65)) {
        window.location.href = '${pageContext.request.contextPath}/login';
    }
});

// Animação de entrada nos elementos
const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, { threshold: 0.1 });
document.querySelectorAll('.aval-card, .exp-item, .prato-item').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(20px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(el);
});
</script>
</body>
</html>

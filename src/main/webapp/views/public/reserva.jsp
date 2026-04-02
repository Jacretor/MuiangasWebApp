<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reserva de Mesa — Muianga's</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Montserrat:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:'Montserrat',sans-serif;background:#0A0806;color:#F0EAE0;min-height:100vh;padding-top:70px;}

        /* Navbar */
        .navbar{position:fixed;top:0;left:0;right:0;z-index:100;display:flex;align-items:center;justify-content:space-between;padding:1.2rem 2.5rem;background:rgba(10,8,6,0.96);border-bottom:1px solid rgba(200,169,81,0.1);backdrop-filter:blur(12px);}
        .navbar-brand{font-family:'Playfair Display',serif;font-size:1.1rem;font-weight:900;letter-spacing:3px;color:#C8A951;}
        .navbar-nav{display:flex;align-items:center;gap:2rem;}
        .navbar-nav a{font-size:0.7rem;font-weight:600;letter-spacing:2px;text-transform:uppercase;color:rgba(255,255,255,0.5);text-decoration:none;transition:color 0.2s;}
        .navbar-nav a:hover,.navbar-nav a.active{color:#C8A951;}
        .btn-nav{padding:0.45rem 1.2rem;border-radius:50px;border:1.5px solid #C8A951;color:#C8A951 !important;font-size:0.65rem !important;font-weight:700 !important;transition:all 0.2s !important;}
        .btn-nav:hover{background:#C8A951 !important;color:#0A0806 !important;}

        /* Hero da reserva */
        .reserva-hero{
            background:linear-gradient(135deg,#120F0C 0%,#1A1410 100%);
            padding:4rem 2rem 3rem;text-align:center;
            border-bottom:1px solid rgba(200,169,81,0.08);
            position:relative;overflow:hidden;
        }
        .reserva-hero::before{
            content:'';position:absolute;inset:0;
            background-image:url('${pageContext.request.contextPath}/imagens_site/fachada.jpeg');
            background-size:cover;background-position:center 40%;
            filter:brightness(0.08) saturate(0.5);
        }
        .reserva-hero-content{position:relative;z-index:2;}
        .reserva-hero-tag{font-size:0.58rem;letter-spacing:5px;text-transform:uppercase;color:#C8A951;margin-bottom:1rem;}
        .reserva-hero-title{font-family:'Playfair Display',serif;font-size:clamp(2.2rem,5vw,3.5rem);font-weight:900;color:#fff;margin-bottom:0.8rem;}
        .reserva-hero-sub{font-size:0.82rem;color:rgba(255,255,255,0.35);letter-spacing:1px;}

        /* Bloco principal */
        .reserva-main{max-width:1000px;margin:0 auto;padding:3rem 2rem 5rem;display:grid;grid-template-columns:1fr 1fr;gap:3rem;align-items:start;}
        @media(max-width:768px){.reserva-main{grid-template-columns:1fr;gap:2rem;padding:2rem 1.5rem 4rem;}}

        /* Formulário */
        .reserva-form-card{background:#161210;border:1px solid rgba(200,169,81,0.1);border-radius:14px;padding:2.5rem;position:relative;overflow:hidden;}
        .reserva-form-card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,#C8A951,#6B4C2A,transparent);}
        .form-section-title{font-size:0.6rem;letter-spacing:3px;text-transform:uppercase;color:#C8A951;margin-bottom:1.5rem;display:flex;align-items:center;gap:0.8rem;}
        .form-section-title::after{content:'';flex:1;height:1px;background:rgba(200,169,81,0.15);}

        .form-group{margin-bottom:1.2rem;}
        .form-label{display:block;font-size:0.6rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:#4A4038;margin-bottom:0.5rem;}
        .form-control{width:100%;padding:0.8rem 1rem;background:#120F0C;border:1.5px solid #1E1814;border-radius:8px;color:#F0EAE0;font-family:'Montserrat',sans-serif;font-size:0.88rem;transition:border-color 0.2s,box-shadow 0.2s;outline:none;}
        .form-control:focus{border-color:#C8A951;box-shadow:0 0 0 3px rgba(200,169,81,0.07);}
        .form-control::placeholder{color:#2A2218;}
        .grid-2{display:grid;grid-template-columns:1fr 1fr;gap:1rem;}
        @media(max-width:480px){.grid-2{grid-template-columns:1fr;}}

        .btn-reservar{width:100%;padding:1rem;border-radius:50px;border:1.5px solid #C8A951;background:transparent;color:#C8A951;font-family:'Montserrat',sans-serif;font-size:0.75rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;cursor:pointer;transition:all 0.25s;margin-top:0.5rem;}
        .btn-reservar:hover{background:#C8A951;color:#0A0806;box-shadow:0 8px 25px rgba(200,169,81,0.3);}

        /* Painel info */
        .reserva-info{display:flex;flex-direction:column;gap:1.5rem;}
        .info-card{background:#161210;border:1px solid #1E1814;border-radius:12px;padding:1.8rem;}
        .info-card-title{font-size:0.6rem;letter-spacing:3px;text-transform:uppercase;color:#C8A951;margin-bottom:1.2rem;}
        .info-row{display:flex;align-items:center;gap:1rem;padding:0.8rem 0;border-bottom:1px solid #120F0C;}
        .info-row:last-child{border-bottom:none;}
        .info-icon{width:36px;height:36px;border-radius:8px;background:rgba(200,169,81,0.06);border:1px solid rgba(200,169,81,0.12);display:flex;align-items:center;justify-content:center;flex-shrink:0;}
        .info-icon svg{stroke:#C8A951;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;}
        .info-lbl{font-size:0.58rem;letter-spacing:2px;text-transform:uppercase;color:#3A3028;}
        .info-val{font-size:0.85rem;color:#C0B4A8;font-weight:600;margin-top:0.1rem;}

        /* Política não comparência */
        .politica-card{background:rgba(200,169,81,0.04);border:1px solid rgba(200,169,81,0.15);border-radius:12px;padding:1.5rem;}
        .politica-title{font-size:0.6rem;letter-spacing:3px;text-transform:uppercase;color:#C8A951;margin-bottom:1rem;display:flex;align-items:center;gap:0.6rem;}
        .politica-title svg{stroke:#C8A951;fill:none;stroke-width:2;stroke-linecap:round;}
        .politica-item{display:flex;align-items:flex-start;gap:0.7rem;margin-bottom:0.8rem;font-size:0.75rem;color:#5A4E44;line-height:1.6;}
        .politica-item svg{stroke:#C8A951;fill:none;stroke-width:2;stroke-linecap:round;flex-shrink:0;margin-top:2px;}

        /* Alertas */
        .alert-success{background:rgba(90,138,90,0.1);border:1px solid rgba(90,138,90,0.3);color:#70B070;border-radius:10px;padding:1rem 1.2rem;margin-bottom:1.5rem;font-size:0.85rem;display:flex;align-items:center;gap:0.8rem;}
        .alert-success svg{stroke:#70B070;fill:none;stroke-width:2;stroke-linecap:round;flex-shrink:0;}
        .alert-danger{background:rgba(138,58,42,0.1);border:1px solid rgba(138,58,42,0.3);color:#D06050;border-radius:10px;padding:1rem 1.2rem;margin-bottom:1.5rem;font-size:0.85rem;}

        /* Auth guard */
        .auth-guard{background:#161210;border:1px solid rgba(200,169,81,0.15);border-radius:14px;padding:3rem 2.5rem;text-align:center;}
        .auth-guard-icon{width:60px;height:60px;border-radius:50%;background:rgba(200,169,81,0.08);border:1px solid rgba(200,169,81,0.2);display:flex;align-items:center;justify-content:center;margin:0 auto 1.5rem;}
        .auth-guard-icon svg{stroke:#C8A951;fill:none;stroke-width:1.5;stroke-linecap:round;}
        .auth-guard-title{font-family:'Playfair Display',serif;font-size:1.4rem;color:#F0EAE0;margin-bottom:0.8rem;}
        .auth-guard-sub{font-size:0.82rem;color:#4A4038;line-height:1.7;margin-bottom:2rem;}
        .btn-criar{display:block;width:100%;padding:0.9rem;border-radius:50px;border:1.5px solid #C8A951;background:transparent;color:#C8A951;font-family:'Montserrat',sans-serif;font-size:0.72rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;text-decoration:none;text-align:center;transition:all 0.25s;margin-bottom:0.8rem;}
        .btn-criar:hover{background:#C8A951;color:#0A0806;}
        .btn-login-link{display:block;width:100%;padding:0.85rem;border-radius:50px;border:1.5px solid #1E1814;background:transparent;color:#5A4E44;font-family:'Montserrat',sans-serif;font-size:0.7rem;font-weight:600;letter-spacing:1.5px;text-transform:uppercase;text-decoration:none;text-align:center;transition:all 0.2s;}
        .btn-login-link:hover{border-color:#C8A951;color:#C8A951;}
        .guard-divider{display:flex;align-items:center;gap:1rem;margin:0.6rem 0;}
        .guard-divider::before,.guard-divider::after{content:'';flex:1;height:1px;background:#1E1814;}
        .guard-divider span{font-size:0.6rem;color:#2A2218;letter-spacing:2px;text-transform:uppercase;}

        footer{background:#0A0806;border-top:1px solid #161210;padding:1.5rem;text-align:center;font-size:0.72rem;color:#2A2218;letter-spacing:1px;}
    </style>
</head>
<body>

<nav class="navbar">
    <div class="navbar-brand">MUIANGA'S</div>
    <ul class="navbar-nav">
        <li><a href="${pageContext.request.contextPath}/">Início</a></li>
        <li><a href="${pageContext.request.contextPath}/menu">Menu</a></li>
        <li><a href="${pageContext.request.contextPath}/reserva" class="active">Reserva</a></li>
        <c:choose>
            <c:when test="${not empty sessionScope.cliente}">
                <li><a href="${pageContext.request.contextPath}/cliente/area" class="btn-nav">${sessionScope.cliente.nome}</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/cliente/login?redirect=/reserva" class="btn-nav">Entrar</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>

<!-- Hero -->
<div class="reserva-hero">
    <div class="reserva-hero-content">
        <div class="reserva-hero-tag">Muianga's Bar &amp; Restaurante</div>
        <h1 class="reserva-hero-title">Reservar uma Mesa</h1>
        <p class="reserva-hero-sub">Chimoio · Manica · Moçambique</p>
    </div>
</div>

<div class="reserva-main">

    <!-- COLUNA ESQUERDA — Formulário ou Auth Guard -->
    <div>
        <c:choose>
            <c:when test="${not empty sessionScope.cliente}">
                <%-- Cliente logado — mostrar formulário --%>
                <c:if test="${not empty sucesso}">
                    <div class="alert-success">
                        <svg viewBox="0 0 24 24" width="20" height="20"><polyline points="20 6 9 17 4 12"/></svg>
                        <div>
                            <strong>Reserva efectuada!</strong><br>
                            <span style="font-size:0.78rem;">Entraremos em contacto pelo WhatsApp para confirmar.</span>
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty erro}">
                    <div class="alert-danger"><c:out value="${erro}"/></div>
                </c:if>

                <div class="reserva-form-card">
                    <div class="form-section-title">Dados da Reserva</div>
                    <form method="post" action="${pageContext.request.contextPath}/reserva">
                        <div class="form-group">
                            <label class="form-label">Nome Completo *</label>
                            <input type="text" name="nome" class="form-control"
                                   value="${sessionScope.cliente.nome}" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Telefone (WhatsApp) *</label>
                            <input type="tel" name="telefone" class="form-control"
                                   value="${sessionScope.cliente.telefone}"
                                   placeholder="+258 84 000 0000" required>
                        </div>
                        <div class="grid-2">
                            <div class="form-group">
                                <label class="form-label">Data *</label>
                                <input type="date" name="data" class="form-control" required
                                       min="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Hora *</label>
                                <input type="time" name="hora" class="form-control" required min="09:00" max="22:00">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Número de Pessoas *</label>
                            <select name="pessoas" class="form-control" required>
                                <option value="">Seleccione</option>
                                <c:forEach var="i" begin="1" end="20">
                                    <option value="${i}">${i} pessoa${i > 1 ? 's' : ''}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Observações</label>
                            <textarea name="observacoes" class="form-control" rows="3"
                                      placeholder="Ex: aniversário, alergias, preferência de mesa..."></textarea>
                        </div>
                        <button type="submit" class="btn-reservar">Confirmar Reserva</button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <%-- Visitante — auth guard --%>
                <div class="auth-guard">
                    <div class="auth-guard-icon">
                        <svg viewBox="0 0 24 24" width="28" height="28"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
                    </div>
                    <h2 class="auth-guard-title">Conta necessária</h2>
                    <p class="auth-guard-sub">Para fazer uma reserva precisas de uma conta. É rápido, gratuito e permite-te acompanhar as tuas reservas.</p>
                    <a href="${pageContext.request.contextPath}/cliente/registo?redirect=/reserva" class="btn-criar">
                        Criar conta gratuita
                    </a>
                    <div class="guard-divider"><span>ou</span></div>
                    <a href="${pageContext.request.contextPath}/cliente/login?redirect=/reserva" class="btn-login-link">
                        Já tenho conta — Entrar
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- COLUNA DIREITA — Informações -->
    <div class="reserva-info">
        <div class="info-card">
            <div class="info-card-title">Informações</div>
            <div class="info-row">
                <div class="info-icon"><svg viewBox="0 0 24 24" width="16" height="16"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
                <div><div class="info-lbl">Horário</div><div class="info-val">9h — 23h (Seg–Sex) · 10h — 23h (Sáb)</div></div>
            </div>
            <div class="info-row">
                <div class="info-icon"><svg viewBox="0 0 24 24" width="16" height="16"><path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 013.07 9.81a19.79 19.79 0 01-3.07-8.68A2 2 0 012 .18h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L6.09 7.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z"/></svg></div>
                <div><div class="info-lbl">Contacto</div><div class="info-val">+258 87 316 905</div></div>
            </div>
            <div class="info-row">
                <div class="info-icon"><svg viewBox="0 0 24 24" width="16" height="16"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg></div>
                <div><div class="info-lbl">Localização</div><div class="info-val">Chimoio, Província de Manica</div></div>
            </div>
        </div>

        <!-- Política de não comparência -->
        <div class="politica-card">
            <div class="politica-title">
                <svg viewBox="0 0 24 24" width="14" height="14"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                Política de Reservas
            </div>
            <div class="politica-item">
                <svg viewBox="0 0 24 24" width="14" height="14"><polyline points="20 6 9 17 4 12"/></svg>
                Receberás confirmação via WhatsApp após submeter.
            </div>
            <div class="politica-item">
                <svg viewBox="0 0 24 24" width="14" height="14"><polyline points="20 6 9 17 4 12"/></svg>
                A mesa é mantida por <strong style="color:#C8A951;">15 minutos</strong> após a hora marcada.
            </div>
            <div class="politica-item">
                <svg viewBox="0 0 24 24" width="14" height="14"><polyline points="20 6 9 17 4 12"/></svg>
                Após 15 min sem aviso, a reserva é automaticamente <strong style="color:#C8A951;">cancelada</strong>.
            </div>
            <div class="politica-item">
                <svg viewBox="0 0 24 24" width="14" height="14"><polyline points="20 6 9 17 4 12"/></svg>
                Para cancelar, contacta-nos com pelo menos <strong style="color:#C8A951;">2 horas</strong> de antecedência.
            </div>
            <div class="politica-item">
                <svg viewBox="0 0 24 24" width="14" height="14"><polyline points="20 6 9 17 4 12"/></svg>
                Não comparências repetidas podem resultar em <strong style="color:#D06050;">restrição de reservas</strong>.
            </div>
        </div>
    </div>
</div>

<footer>
    <strong>MUIANGA'S</strong> Bar &amp; Restaurante · Chimoio, Manica, Moçambique · &copy; 2026
</footer>
</body>
</html>

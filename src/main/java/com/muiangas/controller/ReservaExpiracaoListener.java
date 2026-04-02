package com.muiangas.controller;

import com.muiangas.dao.ReservaDAO;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Listener que verifica reservas expiradas a cada 5 minutos.
 * Reservas confirmadas ou pendentes com hora passada há mais de 15 min
 * são marcadas como 'nao_compareceu' automaticamente.
 */
@WebListener
public class ReservaExpiracaoListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.scheduleAtFixedRate(() -> {
            try {
                ReservaDAO dao = new ReservaDAO();
                int marcadas = dao.marcarExpiradas();
                if (marcadas > 0) {
                    System.out.println("[ReservaExpiracao] " + marcadas + " reserva(s) marcadas como não compareceu.");
                }
            } catch (Exception e) {
                System.err.println("[ReservaExpiracao] Erro: " + e.getMessage());
            }
        }, 5, 5, TimeUnit.MINUTES); // corre a cada 5 minutos
        System.out.println("[ReservaExpiracao] Timer iniciado.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) scheduler.shutdownNow();
    }
}

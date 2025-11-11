package com.duoc.integracion.productos_api.repository;

import com.duoc.integracion.productos_api.model.Product;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    // Aquí puedes definir métodos personalizados si los necesitas en el futuro.
    // Ej: List<Product> findByNameContaining(String name);
}
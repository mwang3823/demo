package com.market.MSA.models.order;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.util.Date;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(
    name = "cancel_orders",
    indexes = {
      @Index(name = "idx_cancel_order", columnList = "order_id"),
      @Index(name = "idx_cancel_status", columnList = "status"),
      @Index(name = "idx_cancel_date", columnList = "cancelDate")
    })
public class CancelOrder {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  Long cancelOrderId;

  Date cancelDate;
  String status;
  String reason;
  double refundAmount;

  @ManyToOne
  @JoinColumn(name = "orderId", nullable = false)
  Order order;
}

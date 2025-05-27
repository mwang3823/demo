package com.market.MSA.responses.order;

import com.market.MSA.responses.product.ProductResponse;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class CartItemResponse {
  Long cartItemId;

  boolean isSelected;
  double price;
  int quantity;

  ProductResponse product;
  CartResponse cart;
}

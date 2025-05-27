package com.market.MSA.requests.order;

import com.market.MSA.validators.DiscountPercentageConstraint;
import com.market.MSA.validators.PositiveAmountConstraint;
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
public class PromoCodeRequest {
  String name;
  String code;
  String description;
  String startDate;
  String endDate;
  String status;
  String discountType;

  @DiscountPercentageConstraint double discountPercentage;

  @PositiveAmountConstraint double minimumOrderValue;

  Long campaignId;
}

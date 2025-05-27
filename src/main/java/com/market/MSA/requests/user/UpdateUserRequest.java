package com.market.MSA.requests.user;

import java.util.List;
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
public class UpdateUserRequest {
  String fullName;

  String email;
  String phoneNumber;
  String birthday;
  String password;
  String address;
  String googleId;

  List<Long> roles;
}

{ config, pkgs, ... }:

let
  users = [
    { name = "sirj"; initialHashedPassword = "$6$j2o3IhM0GDulXWxi$P4WKsNfgK/OCQKgkZon47Rvx0ocit2JinbCDYb6IeQEwm6PlqypV8qxDB5F1NlETd0lulIWdRR9/ZHYzsyZ9T."
; }
    { name = "pengu"; initialHashedPassword = "$6$j2o3IhM0GDulXWxi$P4WKsNfgK/OCQKgkZon47Rvx0ocit2JinbCDYb6IeQEwm6PlqypV8qxDB5F1NlETd0lulIWdRR9/ZHYzsyZ9T.
"; }
    { name = "hik"; initialHashedPassword = "$6$j2o3IhM0GDulXWxi$P4WKsNfgK/OCQKgkZon47Rvx0ocit2JinbCDYb6IeQEwm6PlqypV8qxDB5F1NlETd0lulIWdRR9/ZHYzsyZ9T.
"; }
    { name = "lux"; initialHashedPassword = "$6$j2o3IhM0GDulXWxi$P4WKsNfgK/OCQKgkZon47Rvx0ocit2JinbCDYb6IeQEwm6PlqypV8qxDB5F1NlETd0lulIWdRR9/ZHYzsyZ9T.
"; }
    { name = "norn"; initialHashedPassword = "$6$j2o3IhM0GDulXWxi$P4WKsNfgK/OCQKgkZon47Rvx0ocit2JinbCDYb6IeQEwm6PlqypV8qxDB5F1NlETd0lulIWdRR9/ZHYzsyZ9T."
; }
    { name = "vox"; initialHashedPassword = "$6$j2o3IhM0GDulXWxi$P4WKsNfgK/OCQKgkZon47Rvx0ocit2JinbCDYb6IeQEwm6PlqypV8qxDB5F1NlETd0lulIWdRR9/ZHYzsyZ9T.
"; }
  ];

  groups = [
    { name = "fileshare"; }
  ];
in
{
  users.users = builtins.listToAttrs (map (user: { name = user.name; value = { inherit user.initialHashedPassword; }; }) users);
  users.groups.fileshare.members = map .name users;
}

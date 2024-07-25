{ config, pkgs, ... }:

let
   share_users = [
    rec { 
      name = "sirj";
      config = { 
      initialHashedPassword = "$6$j2o3IhM0GDulXWxi$P4WKsNfgK/OCQKgkZon47Rvx0ocit2JinbCDYb6IeQEwm6PlqypV8qxDB5F1NlETd0lulIWdRR9/ZHYzsyZ9T.";
      extraGroups = [ "frontier" "wilds" "apps" "media" ];
      home="/frontier/${name}";
      isNormalUser = true;
      isSystemUser = false;
      };
    }
    rec { 
      name = "pengu";
      config = { 
      initialHashedPassword = "$6$j2o3IhM0GDulXWxi$P4WKsNfgK/OCQKgkZon47Rvx0ocit2JinbCDYb6IeQEwm6PlqypV8qxDB5F1NlETd0lulIWdRR9/ZHYzsyZ9T.";
      extraGroups = [ "frontier" "wilds" "apps" "media" ];
      home="/frontier/${name}";
      isNormalUser = true;
      isSystemUser = false;
      };
    }
    rec {
       name = "hik";
       config = { 
       initialHashedPassword = "$6$j2o3IhM0GDulXWxi$P4WKsNfgK/OCQKgkZon47Rvx0ocit2JinbCDYb6IeQEwm6PlqypV8qxDB5F1NlETd0lulIWdRR9/ZHYzsyZ9T.";
       extraGroups = [ "frontier" "wilds" "apps" "media" "wheel" ];
       home="/frontier/${name}";
       isNormalUser = true;
       isSystemUser = false;
       };
    }
    rec { 
      name = "lux";
      config = { 
      initialHashedPassword = "$6$j2o3IhM0GDulXWxi$P4WKsNfgK/OCQKgkZon47Rvx0ocit2JinbCDYb6IeQEwm6PlqypV8qxDB5F1NlETd0lulIWdRR9/ZHYzsyZ9T.";
      extraGroups = [ "wilds" "media" ];
      home = "/wilds/${name}";
      isNormalUser = true;
      isSystemUser = false;
      };
    }
    rec { 
      name = "norn";
      config = { 
      initialHashedPassword = "$6$j2o3IhM0GDulXWxi$P4WKsNfgK/OCQKgkZon47Rvx0ocit2JinbCDYb6IeQEwm6PlqypV8qxDB5F1NlETd0lulIWdRR9/ZHYzsyZ9T.";
      extraGroups = [ "wilds" "media" ];
      home = "/wilds/${name}";
      isNormalUser = true;
      isSystemUser = false;
      };
    }
    rec { 
      name = "vox";
      config = {
      initialHashedPassword = "$6$j2o3IhM0GDulXWxi$P4WKsNfgK/OCQKgkZon47Rvx0ocit2JinbCDYb6IeQEwm6PlqypV8qxDB5F1NlETd0lulIWdRR9/ZHYzsyZ9T.";
      extraGroups = [ "wilds" "media" ];
      home = "/wilds/${name}";
      isNormalUser = true;
      isSystemUser = false;
      };
    }
    rec {
       name = "ranka"; 
       config = {
       initialHashedPassword = "$6$j2o3IhM0GDulXWxi$P4WKsNfgK/OCQKgkZon47Rvx0ocit2JinbCDYb6IeQEwm6PlqypV8qxDB5F1NlETd0lulIWdRR9/ZHYzsyZ9T.";
       extraGroups = [ "frontier" "wilds" "apps" "media" "wheel" ];
       isNormalUser = false;
       isSystemUser = true;
       group = "ranka";
       };
    }
  ];

  groups = [
    { name = "media"; }
    { name = "apps"; }
    { name = "ranka"; }
    { name = "frontier"; }
    { name = "wilds"; }
  ];
in
{
  users.mutableUsers = true;
  users.groups = builtins.listToAttrs (map (group: { name = group.name; value = {}; }) groups);
  users.users = builtins.listToAttrs (map 
  (user: { 
    name = user.name; 
    value = { 
      initialHashedPassword = user.config.initialHashedPassword;
      isNormalUser = user.config.isNormalUser;
      isSystemUser = user.config.isSystemUser; shell = pkgs.bash; home= if user.config ? "home" then user.config.home else "/wilds/${user.name}";
      group = if user.config ? "group" then user.config.group else "users";
    }; 
  }) share_users);
}


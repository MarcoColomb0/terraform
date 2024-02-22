terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

locals {
  users = jsondecode(file("azusers.json"))
}

resource "random_password" "password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

provider "azuread" {
  tenant_id = var.TENANTID
}

data "azuread_domains" "terraform" {
  only_initial = true
}

resource "azuread_user" "azusers" {
  for_each = { for idx, user in local.users : idx => user }

  user_principal_name = each.value["user_principal_name"]
  display_name        = each.value["display_name"]
  mail_nickname       = each.value["mail_nickname"]
  password            = random_password.password.result
}

resource "azuread_group" "terraformgroup" {
  display_name     = "Terraform"
  security_enabled = true
}

data "azuread_user" "azusers" {
  for_each = azuread_user.azusers

  user_principal_name = azuread_user.azusers[each.key].user_principal_name
}

resource "azuread_group_member" "terraformgroup" {
  for_each = azuread_user.azusers

  group_object_id  = azuread_group.terraformgroup.id
  member_object_id = each.value.id
}

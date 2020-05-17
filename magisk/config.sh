AUTOMOUNT=true
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=false

print_modname() {
  ui_print "*******************************"
  ui_print "     	MiPay for Mi8          "
  ui_print "*******************************"
}

REPLACE="
"

set_permissions() {
  set_perm_recursive    0  0  0755  0644
}

#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);

__visible struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0x53c99cff, __VMLINUX_SYMBOL_STR(module_layout) },
	{ 0x7dbcb85d, __VMLINUX_SYMBOL_STR(fb_sys_read) },
	{ 0x6ac25c62, __VMLINUX_SYMBOL_STR(driver_unregister) },
	{ 0xd18fdea9, __VMLINUX_SYMBOL_STR(spi_register_driver) },
	{ 0xfbc74f64, __VMLINUX_SYMBOL_STR(__copy_from_user) },
	{ 0x98785e2, __VMLINUX_SYMBOL_STR(register_framebuffer) },
	{ 0x7b7e23b8, __VMLINUX_SYMBOL_STR(fb_deferred_io_init) },
	{ 0x9d669763, __VMLINUX_SYMBOL_STR(memcpy) },
	{ 0x8e865d3c, __VMLINUX_SYMBOL_STR(arm_delay_ops) },
	{ 0x4cda83f8, __VMLINUX_SYMBOL_STR(framebuffer_alloc) },
	{ 0x40a9b349, __VMLINUX_SYMBOL_STR(vzalloc) },
	{ 0x403f9529, __VMLINUX_SYMBOL_STR(gpio_request_one) },
	{ 0x6f8cd704, __VMLINUX_SYMBOL_STR(spi_get_device_id) },
	{ 0x2a3aa678, __VMLINUX_SYMBOL_STR(_test_and_clear_bit) },
	{ 0x27e1a049, __VMLINUX_SYMBOL_STR(printk) },
	{ 0xcc8bb69b, __VMLINUX_SYMBOL_STR(spi_sync) },
	{ 0xfa2a45e, __VMLINUX_SYMBOL_STR(__memzero) },
	{ 0x5f754e5a, __VMLINUX_SYMBOL_STR(memset) },
	{ 0x69abee2b, __VMLINUX_SYMBOL_STR(gpiod_set_raw_value) },
	{ 0xb6c5944b, __VMLINUX_SYMBOL_STR(gpio_to_desc) },
	{ 0xfe990052, __VMLINUX_SYMBOL_STR(gpio_free) },
	{ 0x35660aba, __VMLINUX_SYMBOL_STR(framebuffer_release) },
	{ 0x999e8297, __VMLINUX_SYMBOL_STR(vfree) },
	{ 0xfa16c1ea, __VMLINUX_SYMBOL_STR(fb_deferred_io_cleanup) },
	{ 0x8c8b16ef, __VMLINUX_SYMBOL_STR(unregister_framebuffer) },
	{ 0x5daa5158, __VMLINUX_SYMBOL_STR(sys_imageblit) },
	{ 0x4efb19b8, __VMLINUX_SYMBOL_STR(sys_copyarea) },
	{ 0xbdeb0bf1, __VMLINUX_SYMBOL_STR(sys_fillrect) },
	{ 0xe851bb05, __VMLINUX_SYMBOL_STR(queue_delayed_work_on) },
	{ 0x2d3385d3, __VMLINUX_SYMBOL_STR(system_wq) },
	{ 0x676bbc0f, __VMLINUX_SYMBOL_STR(_set_bit) },
	{ 0x2e5810c6, __VMLINUX_SYMBOL_STR(__aeabi_unwind_cpp_pr1) },
	{ 0xb1ad28e0, __VMLINUX_SYMBOL_STR(__gnu_mcount_nc) },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=fb_sys_fops,sysimgblt,syscopyarea,sysfillrect";

MODULE_ALIAS("spi:vgatonic_card_on_spi");

MODULE_INFO(srcversion, "9CC4555ADDB3455AB9A1E70");

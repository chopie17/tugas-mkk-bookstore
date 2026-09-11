<template>
  <header 
    :class="isDark ? 'bg-slate-900 border-slate-800 text-white' : 'bg-white border-slate-200 text-slate-800 shadow-sm'"
    class="h-16 md:h-20 border-b px-4 md:px-8 flex items-center justify-between shadow-md shrink-0 transition-colors duration-300"
  >
    <!-- Brand Logo on Mobile + Page Title -->
    <div class="flex items-center gap-3">
      <!-- Mobile Logo -->
      <NuxtLink to="/" class="md:hidden flex items-center gap-2">
        <div class="w-8 h-8 rounded-xl bg-indigo-600 flex items-center justify-center text-white font-bold text-sm shadow-md">
          📚
        </div>
        <span class="font-black text-lg tracking-tight font-serif" :class="isDark ? 'text-white' : 'text-slate-900'">
          Book<span class="text-indigo-500">Store</span>
        </span>
      </NuxtLink>

      <!-- Divider on Mobile -->
      <span class="md:hidden font-light" :class="isDark ? 'text-slate-700' : 'text-slate-300'">|</span>

      <!-- Page Title -->
      <h1 class="text-base sm:text-xl md:text-2xl font-black font-serif tracking-tight drop-shadow-sm" :class="isDark ? 'text-white' : 'text-slate-900'">
        {{ pageTitle }}
      </h1>
    </div>

    <!-- Right Controls: Theme Switcher & User Profile -->
    <div class="flex items-center gap-3">
      <!-- Theme Switcher Button -->
      <button 
                  @click="toggleTheme()" 
        :class="isDark ? 'bg-slate-800 border-slate-700 text-slate-200 hover:bg-slate-700' : 'bg-slate-100 border-slate-300 text-slate-700 hover:bg-slate-200'"
        class="flex items-center gap-2 px-3 py-1.5 rounded-full border text-xs font-black transition-all active:scale-95 shadow-sm"
        :title="isDark ? 'Ubah ke Tema Terang' : 'Ubah ke Tema Gelap'"
      >
        <span class="text-sm">{{ isDark ? '🌙' : '☀️' }}</span>
        <span class="hidden sm:inline">{{ isDark ? 'Gelap' : 'Terang' }}</span>
      </button>

      <!-- User Profile Badge -->
      <div 
        :class="isDark ? 'bg-slate-800/90 border-slate-700/80' : 'bg-slate-100 border-slate-200'"
        class="flex items-center gap-2.5 border px-3 py-1.5 rounded-full shadow-inner"
      >
        <div class="text-right leading-tight hidden sm:block">
          <div class="font-extrabold text-xs" :class="isDark ? 'text-white' : 'text-slate-900'">
            {{ authStore.user?.name || 'User' }}
          </div>
          <div class="text-[10px] font-bold text-indigo-500 uppercase tracking-wider">
            {{ authStore.isAdmin ? 'Admin Kasir' : (authStore.user?.role || 'Pelanggan') }}
          </div>
        </div>
        <div class="w-8 h-8 rounded-full ring-2 ring-indigo-500 overflow-hidden bg-indigo-900 flex items-center justify-center text-white font-black text-xs shadow-sm">
          <img 
            v-if="userAvatarUrl" 
            :src="userAvatarUrl" 
            :alt="authStore.user?.name || 'User'"
            class="w-full h-full object-cover"
          />
          <span v-else>
            {{ (authStore.user?.name || 'U').charAt(0).toUpperCase() }}
          </span>
        </div>
      </div>

      <!-- Mobile Nav Menu Drawer Toggle -->
      <button 
        @click="showMobileMenu = !showMobileMenu" 
        :class="isDark ? 'bg-slate-800 text-slate-200 border-slate-700' : 'bg-slate-100 text-slate-700 border-slate-300'"
        class="md:hidden p-2 rounded-xl border active:scale-95"
      >
        <span class="text-lg">☰</span>
      </button>
    </div>

    <!-- Mobile Drawer Overlay Menu -->
    <div v-if="showMobileMenu" class="md:hidden fixed inset-0 bg-slate-950/80 backdrop-blur-md z-50 flex flex-col p-6">
      <div class="flex items-center justify-between border-b border-slate-800 pb-4 mb-6">
        <div class="flex items-center gap-2">
          <div class="w-9 h-9 rounded-xl bg-indigo-600 text-white flex items-center justify-center font-bold">📚</div>
          <span class="font-black text-xl font-serif text-white">Menu BookStore</span>
        </div>
        <button @click="showMobileMenu = false" class="text-slate-400 hover:text-white font-black text-lg p-2">✕</button>
      </div>

      <!-- Mobile Theme Toggle -->
      <div class="mb-4">
        <button 
                    @click="toggleTheme()" 
          class="w-full py-3 bg-slate-900 border border-slate-700 text-white font-black text-xs rounded-2xl flex items-center justify-center gap-2"
        >
          <span>Mode Tema: {{ isDark ? '🌙 Mode Gelap' : '☀️ Mode Terang' }}</span>
        </button>
      </div>

      <nav class="space-y-2 flex-1 overflow-y-auto">
        <NuxtLink 
          v-for="item in mobileNavItems" 
          :key="item.path" 
          :to="item.path"
          @click="showMobileMenu = false"
          class="flex items-center justify-between p-3.5 rounded-2xl text-sm font-extrabold border border-slate-800 transition-colors"
          :class="route.path === item.path ? 'bg-indigo-600 text-white border-indigo-500' : 'bg-slate-900 text-slate-300 hover:bg-slate-800'"
        >
          <span>{{ item.label }}</span>
          <span class="text-xs font-mono text-indigo-400">&rarr;</span>
        </NuxtLink>
      </nav>

      <div class="pt-4 border-t border-slate-800">
        <button 
          @click="handleLogout" 
          class="w-full py-3 bg-rose-600/20 hover:bg-rose-600 text-rose-300 hover:text-white font-black text-sm rounded-2xl border border-rose-500/30 transition-colors"
        >
          🚪 Logout / Keluar
        </button>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
const route = useRoute()
const api = useApi()
const authStore = useAuthStore()
const { isDark, toggleTheme, initTheme } = useTheme()

const showMobileMenu = ref(false)

onMounted(() => {
  initTheme()
})

const pageTitleMap: Record<string, string> = {
  '/admin/kategori': 'Kelola Kategori',
  '/admin/buku': 'Katalog Buku',
  '/admin/pengguna': 'Kelola Pengguna',
  '/admin/kasir': 'Kasir & Scan QR',
  '/admin/laporan': 'Laporan Penjualan',
  '/admin/chat': 'Live Chat Admin',
  '/user/katalog': 'Katalog Buku',
  '/user/keranjang': 'Keranjang Belanja',
  '/user/riwayat': 'Riwayat Pesanan',
  '/user/chat': 'Live Chat Bantuan'
}

const pageTitle = computed(() => {
  return pageTitleMap[route.path] || (route.meta.title as string) || 'BookStore'
})

const adminMobileNav = [
  { label: '🏷️ Kelola Kategori', path: '/admin/kategori' },
  { label: '📚 Katalog Buku', path: '/admin/buku' },
  { label: '👥 Kelola Pengguna', path: '/admin/pengguna' },
  { label: '🛒 Kasir & Scan QR Code', path: '/admin/kasir' },
  { label: '📊 Laporan Penjualan', path: '/admin/laporan' },
  { label: '💬 Live Chat', path: '/admin/chat' },
]

const userMobileNav = [
  { label: '📚 Katalog Buku', path: '/user/katalog' },
  { label: '🛒 Keranjang Belanja', path: '/user/keranjang' },
  { label: '📋 Riwayat Pesanan', path: '/user/riwayat' },
  { label: '💬 Live Chat', path: '/user/chat' },
]

const mobileNavItems = computed(() => {
  return authStore.isAdmin ? adminMobileNav : userMobileNav
})

const userAvatarUrl = computed(() => {
  if (!authStore.user?.foto) return null
  if (authStore.user.foto.startsWith('http')) return authStore.user.foto
  return `${api.apiBase}/storage/${authStore.user.foto}`
})

const handleLogout = async () => {
  showMobileMenu.value = false
  if (confirm('Apakah Anda yakin ingin keluar?')) {
    await authStore.logout()
  }
}
</script>

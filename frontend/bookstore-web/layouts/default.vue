<template>
  <div 
    class="min-h-screen flex flex-col md:flex-row font-sans antialiased pb-16 md:pb-0 transition-colors duration-300"
    :class="isDark ? 'bg-slate-950 text-slate-100' : 'bg-slate-100 text-slate-800'"
  >
    <!-- Desktop Sidebar -->
    <Sidebar />

    <!-- Right Main Content Wrapper -->
    <div class="flex-grow flex flex-col min-w-0">
      <!-- Header Bar -->
      <Header />

      <!-- Main Content Container -->
      <main 
        class="flex-grow p-3 sm:p-6 overflow-y-auto transition-colors duration-300"
        :class="isDark ? 'bg-slate-950' : 'bg-slate-100'"
      >
        <div 
          class="min-h-full rounded-2xl sm:rounded-3xl p-4 sm:p-6 border transition-colors duration-300"
          :class="isDark ? 'bg-slate-900/90 border-slate-800/90 shadow-2xl text-slate-100' : 'bg-white border-slate-200 shadow-sm text-slate-800'"
        >
          <slot />
        </div>
      </main>
    </div>

    <!-- Mobile Bottom Navigation Bar (Shown ONLY on Mobile < md) -->
    <nav 
      :class="isDark ? 'bg-slate-900 border-slate-800 text-slate-400' : 'bg-white border-slate-200 text-slate-600 shadow-lg'"
      class="md:hidden fixed bottom-0 left-0 right-0 h-16 border-t flex items-center justify-around z-40 px-2 shadow-2xl transition-colors duration-300"
    >
      <template v-for="item in bottomNavItems" :key="item.path">
        <NuxtLink 
          :to="item.path" 
          class="flex flex-col items-center justify-center flex-1 h-full text-[10px] font-black transition-colors"
          :class="route.path === item.path ? 'text-indigo-400 font-extrabold' : 'hover:text-slate-400'"
        >
          <span class="text-lg leading-none mb-1">{{ item.icon }}</span>
          <span>{{ item.label }}</span>
        </NuxtLink>
      </template>
    </nav>

    <!-- Floating Chat Widget (Bottom Right Corner on ALL pages) -->
    <FloatingChat />
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const authStore = useAuthStore()
const cartStore = useCartStore()
const { isDark, initTheme } = useTheme()

const adminBottomNav = [
  { label: 'Kategori', path: '/admin/kategori', icon: '🏷️' },
  { label: 'Buku', path: '/admin/buku', icon: '📚' },
  { label: 'Kasir', path: '/admin/kasir', icon: '🛒' },
  { label: 'Laporan', path: '/admin/laporan', icon: '📊' },
  { label: 'Chat', path: '/admin/chat', icon: '💬' },
]

const userBottomNav = [
  { label: 'Katalog', path: '/user/katalog', icon: '📚' },
  { label: 'Keranjang', path: '/user/keranjang', icon: '🛒' },
  { label: 'Riwayat', path: '/user/riwayat', icon: '📋' },
  { label: 'Chat', path: '/user/chat', icon: '💬' },
]

const bottomNavItems = computed(() => {
  return authStore.isAdmin ? adminBottomNav : userBottomNav
})

onMounted(async () => {
  initTheme()
  if (!authStore.initialized) {
    await authStore.fetchUser()
  }
  if (authStore.isAuthenticated) {
    await cartStore.fetchCart()
  }
})
</script>

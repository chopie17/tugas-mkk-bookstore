<template>
  <aside 
    :class="isDark ? 'bg-slate-900 border-slate-800 text-slate-100' : 'bg-white border-slate-200 text-slate-800 shadow-md'"
    class="hidden md:flex w-64 min-h-screen p-5 flex-col justify-between border-r shadow-xl select-none shrink-0 transition-colors duration-300"
  >
    <div>
      <!-- Brand Logo -->
      <NuxtLink to="/" class="flex items-center gap-3 px-2 py-3 mb-6 group">
        <div class="w-10 h-10 rounded-2xl bg-indigo-600 text-white flex items-center justify-center font-bold text-xl shadow-lg shadow-indigo-500/30 group-hover:scale-105 transition-transform">
          <LucideBookOpen class="w-5 h-5 text-white" />
        </div>
        <span class="font-black text-2xl tracking-tight font-serif" :class="isDark ? 'text-white' : 'text-slate-900'">
          Book<span class="text-indigo-500">Store</span>
        </span>
      </NuxtLink>

      <!-- Sidebar Search Box -->
      <div class="relative mb-6">
        <input 
          v-model="searchQuery" 
          type="text" 
          placeholder="Cari menu..." 
          :class="isDark ? 'bg-slate-800/80 border-slate-700 text-white focus:bg-slate-800' : 'bg-slate-100 border-slate-300 text-slate-900 focus:bg-white'"
          class="w-full pl-9 pr-4 py-2.5 text-xs rounded-xl border outline-none shadow-sm transition-all focus:ring-2 focus:ring-indigo-500 font-medium"
        />
        <LucideSearch class="w-4 h-4 text-slate-400 absolute left-3 top-3" />
      </div>

      <!-- Navigation Menu -->
      <nav class="space-y-1.5">
        <template v-for="item in filteredNavItems" :key="item.path">
          <NuxtLink 
            :to="item.path" 
            class="group relative flex items-center gap-3 px-4 py-3 rounded-xl text-xs font-black transition-all duration-200"
            :class="[
              isRouteActive(item.path) 
                ? 'text-white bg-indigo-600 shadow-md shadow-indigo-600/30' 
                : (isDark ? 'text-slate-400 hover:text-white hover:bg-slate-800/60' : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100')
            ]"
          >
            <component :is="item.icon" class="w-4 h-4 transition-transform group-hover:scale-110" :class="isRouteActive(item.path) ? 'text-white' : 'text-slate-400'" />
            <span>{{ item.label }}</span>
          </NuxtLink>

          <!-- Divider -->
          <div v-if="item.divider" class="my-3 border-t" :class="isDark ? 'border-slate-800' : 'border-slate-200'"></div>
        </template>
      </nav>
    </div>

    <!-- Bottom Actions (Chat & Logout) -->
    <div class="space-y-1 pt-4 border-t" :class="isDark ? 'border-slate-800' : 'border-slate-200'">
      <NuxtLink 
        :to="chatPath" 
        class="group relative flex items-center gap-3 px-4 py-3 rounded-xl text-xs font-black transition-all duration-200"
        :class="[
          isRouteActive(chatPath) 
            ? 'text-white bg-indigo-600 shadow-md shadow-indigo-600/30' 
            : (isDark ? 'text-slate-400 hover:text-white hover:bg-slate-800/60' : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100')
        ]"
      >
        <LucideMessageSquare class="w-4 h-4 text-slate-400 transition-transform group-hover:scale-110" />
        <span>Live Chat</span>
      </NuxtLink>

      <button 
        @click="handleLogout" 
        class="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-xs font-black transition-all duration-200"
        :class="isDark ? 'text-slate-400 hover:text-rose-400 hover:bg-rose-500/10' : 'text-slate-600 hover:text-rose-600 hover:bg-rose-50'"
      >
        <LucideLogOut class="w-4 h-4 text-slate-400 group-hover:text-rose-400" />
        <span>Keluar / Logout</span>
      </button>
    </div>
  </aside>
</template>

<script setup lang="ts">
import { 
  BookOpen as LucideBookOpen, 
  Search as LucideSearch, 
  Tag as LucideTag, 
  Book as LucideBook, 
  Users as LucideUsers, 
  ShoppingBag as LucideShoppingBag, 
  FileText as LucideFileText, 
  ShoppingCart as LucideShoppingCart, 
  History as LucideHistory, 
  MessageSquare as LucideMessageSquare, 
  LogOut as LucideLogOut,
  Store as LucideStore
} from 'lucide-vue-next'

const route = useRoute()
const authStore = useAuthStore()
const { isDark } = useTheme()

const searchQuery = ref('')

const chatPath = computed(() => {
  return authStore.isAdmin ? '/admin/chat' : '/user/chat'
})

const adminNavItems = [
  { label: 'Kategori', path: '/admin/kategori', icon: LucideTag },
  { label: 'Katalog Buku', path: '/admin/buku', icon: LucideBook },
  { label: 'Pengguna', path: '/admin/pengguna', icon: LucideUsers },
  { label: 'Kasir & Scan', path: '/admin/kasir', icon: LucideShoppingBag },
  { label: 'Laporan', path: '/admin/laporan', icon: LucideFileText, divider: true },
]

const userNavItems = [
  { label: 'Katalog Buku', path: '/user/katalog', icon: LucideStore },
  { label: 'Keranjang', path: '/user/keranjang', icon: LucideShoppingCart },
  { label: 'Riwayat Pesanan', path: '/user/riwayat', icon: LucideHistory, divider: true },
]

const navItems = computed(() => {
  return authStore.isAdmin ? adminNavItems : userNavItems
})

const filteredNavItems = computed(() => {
  if (!searchQuery.value.trim()) return navItems.value
  const q = searchQuery.value.toLowerCase()
  return navItems.value.filter(item => item.label.toLowerCase().includes(q))
})

const isRouteActive = (path: string) => {
  return route.path === path || route.path.startsWith(path + '/')
}

const handleLogout = async () => {
  if (confirm('Apakah Anda yakin ingin keluar?')) {
    await authStore.logout()
  }
}
</script>

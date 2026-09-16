<template>
  <header 
    :class="isDark ? 'bg-slate-900/95 border-slate-800 shadow-sm text-slate-100' : 'bg-[#FFF8EC] border-b-2.5 border-[#1A1A1A] shadow-[0_4px_0px_#1A1A1A] text-slate-900'" 
    class="sticky top-0 z-50 transition-colors duration-200"
  >
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-16">
        <!-- Logo -->
        <NuxtLink :to="authStore.isAdmin ? '/admin/kategori' : '/'" class="flex items-center gap-2 group">
          <div 
            :class="isDark ? 'bg-indigo-600 text-white' : 'bg-[#C8F53F] text-black border-2 border-black shadow-[2.5px_2.5px_0px_#1A1A1A]'"
            class="w-10 h-10 rounded-xl flex items-center justify-center font-bold text-xl group-hover:scale-105 transition-transform"
          >
            📚
          </div>
          <span class="font-black text-xl" :class="isDark ? 'text-white' : 'text-slate-900'">
            Book<span :class="isDark ? 'text-indigo-400 bg-slate-800 px-1.5 py-0.5 rounded-lg border border-slate-700' : 'bg-[#C8F53F] text-black px-1.5 py-0.5 rounded-lg border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'">Store</span>
          </span>
        </NuxtLink>

        <!-- Public Navigation Links -->
        <nav class="hidden md:flex items-center gap-6 text-sm font-black" :class="isDark ? 'text-slate-200' : 'text-slate-900'">
          <NuxtLink 
            to="/" 
            class="px-3 py-1.5 rounded-xl border-2 transition-all"
            :class="isDark ? 'border-transparent hover:border-slate-700 hover:bg-slate-800' : 'border-transparent hover:border-black hover:bg-[#C8F53F] hover:shadow-[2px_2px_0px_#1A1A1A]'" 
            :active-class="isDark ? 'bg-indigo-600 text-white border-indigo-500' : 'bg-[#C8F53F] border-black shadow-[2px_2px_0px_#1A1A1A]'"
          >Home</NuxtLink>
          <NuxtLink 
            to="/user/katalog" 
            class="px-3 py-1.5 rounded-xl border-2 transition-all"
            :class="isDark ? 'border-transparent hover:border-slate-700 hover:bg-slate-800' : 'border-transparent hover:border-black hover:bg-[#C8F53F] hover:shadow-[2px_2px_0px_#1A1A1A]'" 
            :active-class="isDark ? 'bg-indigo-600 text-white border-indigo-500' : 'bg-[#C8F53F] border-black shadow-[2px_2px_0px_#1A1A1A]'"
          >Katalog Buku</NuxtLink>
          <NuxtLink 
            to="/our-story" 
            class="px-3 py-1.5 rounded-xl border-2 transition-all"
            :class="isDark ? 'border-transparent hover:border-slate-700 hover:bg-slate-800' : 'border-transparent hover:border-black hover:bg-[#C8F53F] hover:shadow-[2px_2px_0px_#1A1A1A]'" 
            :active-class="isDark ? 'bg-indigo-600 text-white border-indigo-500' : 'bg-[#C8F53F] border-black shadow-[2px_2px_0px_#1A1A1A]'"
          >Our Story</NuxtLink>
          <NuxtLink 
            to="/blog" 
            class="px-3 py-1.5 rounded-xl border-2 transition-all"
            :class="isDark ? 'border-transparent hover:border-slate-700 hover:bg-slate-800' : 'border-transparent hover:border-black hover:bg-[#C8F53F] hover:shadow-[2px_2px_0px_#1A1A1A]'" 
            :active-class="isDark ? 'bg-indigo-600 text-white border-indigo-500' : 'bg-[#C8F53F] border-black shadow-[2px_2px_0px_#1A1A1A]'"
          >Blog</NuxtLink>
          <NuxtLink 
            to="/contact" 
            class="px-3 py-1.5 rounded-xl border-2 transition-all"
            :class="isDark ? 'border-transparent hover:border-slate-700 hover:bg-slate-800' : 'border-transparent hover:border-black hover:bg-[#C8F53F] hover:shadow-[2px_2px_0px_#1A1A1A]'" 
            :active-class="isDark ? 'bg-indigo-600 text-white border-indigo-500' : 'bg-[#C8F53F] border-black shadow-[2px_2px_0px_#1A1A1A]'"
          >Contact</NuxtLink>
        </nav>

        <!-- Right User Actions -->
        <div class="flex items-center gap-3">
          <!-- Theme Toggle Button -->
          <button 
            @click="toggleTheme()" 
            :class="isDark ? 'bg-slate-800 border border-slate-700 text-slate-300 hover:bg-slate-700' : 'bg-[#FFE566] border-2 border-[#1A1A1A] text-black shadow-[2.5px_2.5px_0px_#1A1A1A] hover:translate-x-[-1px] hover:translate-y-[-1px] active:translate-x-[1px] active:translate-y-[1px]'"
            class="flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-black transition-all duration-200"
            :title="isDark ? 'Ubah ke Tema Retro Terang' : 'Ubah ke Tema Gelap'"
          >
            <span class="text-sm">{{ isDark ? '🌙' : '☀️' }}</span>
            <span class="hidden sm:inline text-[11px]">{{ isDark ? 'Dark' : 'Light' }}</span>
          </button>

          <!-- Cart Icon (For User) -->
          <button 
            @click="handleCartClick" 
            :class="isDark ? 'bg-slate-800 border border-slate-700 text-white' : 'bg-[#FFF8EC] border-2 border-black shadow-[2px_2px_0px_#1A1A1A] text-slate-900'"
            class="relative p-2 rounded-xl transition-transform active:translate-x-[1px] active:translate-y-[1px]"
            title="Keranjang Belanja"
          >
            <span class="text-xl">🛒</span>
            <span v-if="cartStore.totalItems > 0 && authStore.isAuthenticated" :class="isDark ? 'bg-indigo-500 text-white border-slate-900' : 'bg-[#FFB7B2] border-2 border-black text-black shadow-[1px_1px_0px_#1A1A1A]'" class="absolute -top-1.5 -right-1.5 text-xs font-black w-5 h-5 rounded-full flex items-center justify-center border">
              {{ cartStore.totalItems }}
            </span>
          </button>

          <!-- Logged In User / Admin Menu -->
          <div v-if="authStore.isAuthenticated" class="flex items-center gap-3">
            <NuxtLink v-if="authStore.isAdmin" to="/admin/kategori" :class="isDark ? 'bg-indigo-600 hover:bg-indigo-700 text-white' : 'bg-[#FFE566] text-black border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'" class="hidden sm:inline-flex items-center px-3 py-1.5 text-xs font-black rounded-xl transition-transform active:translate-x-[1px] active:translate-y-[1px]">
              ⚙️ Dashboard Admin
            </NuxtLink>

            <NuxtLink v-else to="/user/riwayat" :class="isDark ? 'bg-indigo-600 hover:bg-indigo-700 text-white' : 'bg-[#D4B8FF] text-black border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'" class="hidden sm:inline-flex items-center px-3 py-1.5 text-xs font-black rounded-xl transition-transform active:translate-x-[1px] active:translate-y-[1px]">
              📋 Riwayat Pesanan
            </NuxtLink>

            <NuxtLink :to="authStore.isAdmin ? '/admin/chat' : '/user/chat'" :class="isDark ? 'bg-slate-800 border border-slate-700 text-white' : 'bg-[#FFD4A3] border-2 border-black shadow-[2px_2px_0px_#1A1A1A] text-slate-900'" class="p-2 rounded-xl transition-transform active:translate-x-[1px] active:translate-y-[1px]" title="Live Chat">
              💬
            </NuxtLink>

            <div class="flex items-center gap-2 pl-2 border-l" :class="isDark ? 'border-slate-700' : 'border-black border-l-2'">
              <div :class="isDark ? 'bg-indigo-600 text-white' : 'bg-[#C8F53F] border-2 border-black text-black shadow-[1.5px_1.5px_0px_#1A1A1A]'" class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-black">
                {{ authStore.user?.name?.charAt(0).toUpperCase() }}
              </div>
              <button @click="authStore.logout()" :class="isDark ? 'bg-rose-900/60 hover:bg-rose-900 text-rose-200 border-rose-700/50' : 'bg-[#FFB7B2] border-2 border-black text-black shadow-[1.5px_1.5px_0px_#1A1A1A]'" class="px-2.5 py-1 text-xs font-black rounded-xl border transition-transform active:translate-x-[1px] active:translate-y-[1px]">
                Logout
              </button>
            </div>
          </div>

          <!-- Guest Login / Register -->
          <div v-else class="flex items-center gap-2">
            <NuxtLink 
              to="/login" 
              :class="isDark ? 'text-slate-200 hover:bg-slate-800 border-slate-700' : 'text-black hover:bg-[#FFE566] border-transparent hover:border-black hover:shadow-[2px_2px_0px_#1A1A1A]'"
              class="px-4 py-2 text-sm font-black border-2 rounded-xl transition-all"
            >
              Login
            </NuxtLink>
            <NuxtLink 
              to="/register" 
              :class="isDark ? 'bg-indigo-600 hover:bg-indigo-700 text-white border-indigo-500 shadow-md shadow-indigo-600/30' : 'bg-[#C8F53F] border-2 border-black text-black shadow-[3px_3px_0px_#1A1A1A] hover:translate-x-[-1px] hover:translate-y-[-1px] active:translate-x-[1px] active:translate-y-[1px]'"
              class="px-4 py-2 text-sm font-black border rounded-xl transition-all"
            >
              Register
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
const authStore = useAuthStore()
const cartStore = useCartStore()
const { isDark, toggleTheme, initTheme } = useTheme()

const handleCartClick = () => {
  if (!authStore.isAuthenticated) {
    const toast = useToast()
    toast.error('Silakan login terlebih dahulu untuk mengakses keranjang belanja.')
    navigateTo('/login')
    return
  }
  navigateTo('/user/keranjang')
}

onMounted(async () => {
  initTheme()
  if (!authStore.initialized) {
    await authStore.fetchUser()
  }
})
</script>


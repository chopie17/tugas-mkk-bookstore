<template>
  <header class="sticky top-0 z-50 glass-panel border-b border-slate-200/80 shadow-sm">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-16">
        <!-- Logo -->
        <NuxtLink to="/" class="flex items-center gap-2 group">
          <div class="w-10 h-10 rounded-xl bg-gradient-to-tr from-indigo-600 to-violet-500 flex items-center justify-center text-white font-bold text-xl shadow-md shadow-indigo-500/20 group-hover:scale-105 transition-transform">
            📚
          </div>
          <span class="font-bold text-xl bg-gradient-to-r from-indigo-600 via-violet-600 to-purple-600 bg-clip-text text-transparent">
            BookStore
          </span>
        </NuxtLink>

        <!-- Public Navigation Links -->
        <nav class="hidden md:flex items-center gap-6 text-sm font-medium text-slate-600">
          <NuxtLink to="/" class="hover:text-indigo-600 transition-colors" active-class="text-indigo-600 font-semibold">Home</NuxtLink>
          <NuxtLink to="/user/katalog" class="hover:text-indigo-600 transition-colors" active-class="text-indigo-600 font-semibold">Katalog Buku</NuxtLink>
          <NuxtLink to="/our-story" class="hover:text-indigo-600 transition-colors" active-class="text-indigo-600 font-semibold">Our Story</NuxtLink>
          <NuxtLink to="/blog" class="hover:text-indigo-600 transition-colors" active-class="text-indigo-600 font-semibold">Blog</NuxtLink>
          <NuxtLink to="/contact" class="hover:text-indigo-600 transition-colors" active-class="text-indigo-600 font-semibold">Contact</NuxtLink>
        </nav>

        <!-- Right User Actions -->
        <div class="flex items-center gap-4">
          <!-- Cart Icon (For User) -->
          <NuxtLink to="/user/keranjang" class="relative p-2 rounded-lg hover:bg-slate-100 text-slate-600 transition-colors">
            <span class="text-xl">🛒</span>
            <span v-if="cartStore.totalItems > 0" class="absolute -top-1 -right-1 bg-rose-500 text-white text-xs font-bold w-5 h-5 rounded-full flex items-center justify-center animate-pulse">
              {{ cartStore.totalItems }}
            </span>
          </NuxtLink>

          <!-- Logged In User / Admin Menu -->
          <div v-if="authStore.isAuthenticated" class="flex items-center gap-3">
            <NuxtLink v-if="authStore.isAdmin" to="/admin/kategori" class="hidden sm:inline-flex items-center px-3 py-1.5 text-xs font-semibold rounded-lg bg-indigo-50 text-indigo-700 border border-indigo-200 hover:bg-indigo-100 transition-colors">
              ⚙️ Dashboard Admin
            </NuxtLink>

            <NuxtLink v-else to="/user/riwayat" class="hidden sm:inline-flex items-center px-3 py-1.5 text-xs font-semibold rounded-lg bg-slate-100 text-slate-700 hover:bg-slate-200 transition-colors">
              📋 Riwayat Pesanan
            </NuxtLink>

            <NuxtLink :to="authStore.isAdmin ? '/admin/chat' : '/user/chat'" class="p-2 rounded-lg hover:bg-slate-100 text-slate-600 transition-colors" title="Live Chat">
              💬
            </NuxtLink>

            <div class="flex items-center gap-2 pl-2 border-l border-slate-200">
              <div class="w-8 h-8 rounded-full bg-indigo-600 text-white flex items-center justify-center text-sm font-bold shadow-sm">
                {{ authStore.user?.name?.charAt(0).toUpperCase() }}
              </div>
              <button @click="authStore.logout()" class="p-2 text-xs text-rose-600 hover:text-rose-700 hover:bg-rose-50 rounded-lg transition-colors font-medium">
                Logout
              </button>
            </div>
          </div>

          <!-- Guest Login / Register -->
          <div v-else class="flex items-center gap-2">
            <NuxtLink to="/login" class="px-4 py-2 text-sm font-medium text-slate-700 hover:text-indigo-600 transition-colors">
              Login
            </NuxtLink>
            <NuxtLink to="/register" class="px-4 py-2 text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 rounded-xl shadow-md shadow-indigo-500/20 transition-all hover:scale-105">
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

onMounted(async () => {
  if (!authStore.initialized) {
    await authStore.fetchUser()
  }
})
</script>

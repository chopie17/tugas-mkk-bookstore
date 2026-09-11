<template>
  <footer class="bg-slate-900 text-slate-400 py-12 border-t border-slate-800 mt-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
        <div>
          <div class="flex items-center gap-2 mb-4">
            <span class="text-2xl">📚</span>
            <span class="text-xl font-bold text-white">BookStore</span>
          </div>
          <p class="text-sm text-slate-400 leading-relaxed">
            Platform toko buku online terlengkap dengan koleksi buku berkualitas untuk mencerdaskan kehidupan bangsa.
          </p>
        </div>
        <div>
          <h4 class="text-white font-semibold mb-4">Navigasi Utama</h4>
          <ul class="space-y-2 text-sm">
            <li><NuxtLink to="/" class="hover:text-white transition-colors">Home</NuxtLink></li>
            <li><NuxtLink to="/user/katalog" class="hover:text-white transition-colors">Katalog Buku</NuxtLink></li>
            <li><NuxtLink to="/our-story" class="hover:text-white transition-colors">Our Story</NuxtLink></li>
            <li><NuxtLink to="/blog" class="hover:text-white transition-colors">Blog & Berita</NuxtLink></li>
          </ul>
        </div>
        <div>
          <h4 class="text-white font-semibold mb-4">Bantuan & Kontak</h4>
          <ul class="space-y-2 text-sm">
            <li><NuxtLink to="/contact" class="hover:text-white transition-colors">Hubungi Kami</NuxtLink></li>
            <li><NuxtLink to="/forget-password" class="hover:text-white transition-colors">Lupa Password</NuxtLink></li>
            <li><NuxtLink to="/user/chat" class="hover:text-white transition-colors">Live Chat Support</NuxtLink></li>
          </ul>
        </div>
        <div>
          <h4 class="text-white font-semibold mb-4">Jam Operasional</h4>
          <p class="text-sm text-slate-400">Senin - Sabtu: 08.00 - 20.00 WIB</p>
          <p class="text-sm text-slate-400 mt-2">Dukungan Sistem: Laravel 12 API + Nuxt 3 SPA</p>
        </div>
      </div>
      <div class="border-t border-slate-800 mt-10 pt-6 text-center text-xs text-slate-500">
        &copy; {{ new Date().getFullYear() }} BookStore Project. All rights reserved.
      </div>
    </div>
  </footer>
</template>

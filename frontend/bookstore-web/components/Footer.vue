<template>
  <footer 
    :class="isDark ? 'bg-slate-900 border-t border-slate-800 text-slate-300' : 'bg-[#FFF8EC] border-t-2.5 border-[#1A1A1A] text-slate-900'"
    class="py-12 mt-20 font-['Space_Grotesk'] transition-colors duration-200"
  >
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
        <div>
          <div class="flex items-center gap-2 mb-4">
            <span class="text-2xl">📚</span>
            <span 
              :class="isDark ? 'bg-indigo-600 text-white border-indigo-500' : 'bg-[#C8F53F] text-slate-900 border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'"
              class="text-xl font-black px-2 py-0.5 rounded-lg border"
            >BookStore</span>
          </div>
          <p :class="isDark ? 'text-slate-400' : 'text-slate-700'" class="text-xs font-bold leading-relaxed">
            Platform toko buku online terlengkap dengan koleksi buku berkualitas untuk mencerdaskan kehidupan bangsa.
          </p>
        </div>
        <div>
          <h4 
            :class="isDark ? 'bg-slate-800 text-indigo-400 border-slate-700' : 'bg-[#D4B8FF] text-slate-900 border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'"
            class="font-black mb-4 uppercase tracking-wider text-xs px-2 py-1 inline-block rounded border"
          >Navigasi Utama</h4>
          <ul class="space-y-2 text-xs font-bold">
            <li><NuxtLink to="/" :class="isDark ? 'hover:text-indigo-400' : 'hover:underline hover:text-indigo-600'" class="transition-colors">Home</NuxtLink></li>
            <li><NuxtLink to="/user/katalog" :class="isDark ? 'hover:text-indigo-400' : 'hover:underline hover:text-indigo-600'" class="transition-colors">Katalog Buku</NuxtLink></li>
            <li><NuxtLink to="/our-story" :class="isDark ? 'hover:text-indigo-400' : 'hover:underline hover:text-indigo-600'" class="transition-colors">Our Story</NuxtLink></li>
            <li><NuxtLink to="/blog" :class="isDark ? 'hover:text-indigo-400' : 'hover:underline hover:text-indigo-600'" class="transition-colors">Blog & Berita</NuxtLink></li>
          </ul>
        </div>
        <div>
          <h4 
            :class="isDark ? 'bg-slate-800 text-indigo-400 border-slate-700' : 'bg-[#FFD4A3] text-slate-900 border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'"
            class="font-black mb-4 uppercase tracking-wider text-xs px-2 py-1 inline-block rounded border"
          >Bantuan & Kontak</h4>
          <ul class="space-y-2 text-xs font-bold">
            <li><NuxtLink to="/contact" :class="isDark ? 'hover:text-indigo-400' : 'hover:underline hover:text-indigo-600'" class="transition-colors">Hubungi Kami</NuxtLink></li>
            <li><NuxtLink to="/forget-password" :class="isDark ? 'hover:text-indigo-400' : 'hover:underline hover:text-indigo-600'" class="transition-colors">Lupa Password</NuxtLink></li>
            <li><NuxtLink to="/user/chat" :class="isDark ? 'hover:text-indigo-400' : 'hover:underline hover:text-indigo-600'" class="transition-colors">Live Chat Support</NuxtLink></li>
          </ul>
        </div>
        <div>
          <h4 
            :class="isDark ? 'bg-slate-800 text-indigo-400 border-slate-700' : 'bg-[#FFE566] text-slate-900 border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'"
            class="font-black mb-4 uppercase tracking-wider text-xs px-2 py-1 inline-block rounded border"
          >Jam Operasional</h4>
          <p :class="isDark ? 'text-slate-400' : 'text-slate-700'" class="text-xs font-bold">Senin - Sabtu: 08.00 - 20.00 WIB</p>
          <p :class="isDark ? 'text-slate-500' : 'text-slate-500'" class="text-xs font-bold mt-2">Dukungan Sistem: Laravel 12 API + Nuxt 3 SPA</p>
        </div>
      </div>
      <div 
        :class="isDark ? 'border-slate-800 text-slate-500' : 'border-black text-slate-700 border-t-2'"
        class="border-t mt-10 pt-6 text-center text-xs font-black"
      >
        &copy; {{ new Date().getFullYear() }} BookStore Project. All rights reserved.
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
const { isDark } = useTheme()
</script>


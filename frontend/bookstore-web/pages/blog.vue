<template>
  <div class="max-w-6xl mx-auto px-4 py-16">
    <div class="text-center mb-12">
      <span class="px-3.5 py-1.5 rounded-full bg-indigo-50 text-indigo-600 text-xs font-semibold">BLOG & ARTIKEL</span>
      <h1 class="text-3xl font-extrabold text-slate-900 mt-4 mb-4">Berita & Informasi Literatur</h1>
      <p class="text-slate-600">Temukan rekomendasi buku, ulasan, dan tips membaca menarik di sini.</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      <div v-for="post in posts" :key="post.id" class="bg-white rounded-2xl border border-slate-200/80 shadow-sm overflow-hidden hover:shadow-md transition-shadow">
        <div class="h-44 bg-indigo-100 flex items-center justify-center text-4xl">
          {{ post.icon }}
        </div>
        <div class="p-6">
          <span class="text-xs font-semibold text-indigo-600 mb-2 block">{{ post.category }}</span>
          <h3 class="font-bold text-slate-900 text-lg mb-2">{{ post.title }}</h3>
          <p class="text-xs text-slate-500 mb-4">{{ post.date }} • Oleh {{ post.author }}</p>
          <p class="text-xs text-slate-600 line-clamp-3 mb-4 leading-relaxed">{{ post.excerpt }}</p>
          <button class="text-xs font-semibold text-indigo-600 hover:text-indigo-700">Baca Selengkapnya &rarr;</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const posts = ref([
  {
    id: 1,
    icon: '📖',
    category: 'Rekomendasi',
    title: '5 Buku Fiksi Indonesia Terbaik yang Wajib Dibaca Tahun Ini',
    date: '10 September 2026',
    author: 'Tim Redaksi',
    excerpt: 'Daftar novel fiksi penuh inspirasi dan nilai budaya tinggi yang siap menemani waktu luang Anda.'
  },
  {
    id: 2,
    icon: '💻',
    category: 'Teknologi',
    title: 'Belajar Fullstack Web Development dengan Laravel 12 & Nuxt 3',
    date: '08 September 2026',
    author: 'Admin Tech',
    excerpt: 'Panduan langkah demi langkah merancang arsitektur API modern dan Single Page Application.'
  },
  {
    id: 3,
    icon: '💡',
    category: 'Tips Membaca',
    title: 'Cara Membangun Kebiasaan Membaca Buku 15 Menit Setiap Hari',
    date: '05 September 2026',
    author: 'Penulis Tamu',
    excerpt: 'Tips sederhana namun efektif untuk konsisten membaca buku di tengah kesibukan harian.'
  }
])
</script>

<template>
  <div class="max-w-6xl mx-auto px-4 py-8">
    <div class="text-center mb-12">
      <span 
        :class="isDark ? 'bg-indigo-900/60 text-indigo-300 border-indigo-700' : 'bg-[#C8F53F] text-black border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'"
        class="px-3.5 py-1.5 rounded-full text-xs font-black border"
      >BLOG & ARTIKEL</span>
      <h1 :class="isDark ? 'text-white' : 'text-slate-900'" class="text-3xl font-black mt-4 mb-4">Berita & Informasi Literatur</h1>
      <p :class="isDark ? 'text-slate-400' : 'text-slate-700'" class="font-bold text-sm">Temukan rekomendasi buku, ulasan, dan tips membaca menarik di sini.</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      <div 
        v-for="(post, idx) in posts" 
        :key="post.id" 
        :class="[
          isDark 
            ? 'bg-slate-900 border-slate-800 text-slate-100 shadow-xl' 
            : (idx % 3 === 0 ? 'bg-[#FFF8EC]' : idx % 3 === 1 ? 'bg-[#D4B8FF]' : 'bg-[#FFD4A3]') + ' border-3 border-black shadow-[6px_6px_0px_#1A1A1A] hover:translate-x-[-2px] hover:translate-y-[-2px]'
        ]"
        class="rounded-3xl border overflow-hidden transition-all flex flex-col justify-between"
      >
        <div>
          <div :class="isDark ? 'bg-slate-950 border-slate-800' : 'bg-[#FAF7F0] border-b-2 border-black'" class="h-44 border-b flex items-center justify-center text-5xl">
            {{ post.icon }}
          </div>
          <div class="p-6">
            <span :class="isDark ? 'bg-indigo-900/80 text-indigo-200 border-indigo-700' : 'bg-[#C8F53F] text-black border border-black shadow-[1px_1px_0px_#1A1A1A]'" class="text-[10px] font-black uppercase px-2 py-0.5 rounded border mb-3 inline-block">{{ post.category }}</span>
            <h3 :class="isDark ? 'text-white' : 'text-slate-900'" class="font-black text-lg mb-2 leading-snug">{{ post.title }}</h3>
            <p :class="isDark ? 'text-slate-400' : 'text-slate-600'" class="text-xs font-bold mb-4">{{ post.date }} • Oleh {{ post.author }}</p>
            <p :class="isDark ? 'text-slate-300' : 'text-slate-800'" class="text-xs font-medium line-clamp-3 mb-4 leading-relaxed">{{ post.excerpt }}</p>
          </div>
        </div>
        <div class="p-6 pt-0">
          <button :class="isDark ? 'bg-slate-800 hover:bg-slate-700 text-indigo-400 border-slate-700' : 'bg-white text-black border-2 border-black shadow-[2px_2px_0px_#1A1A1A] hover:bg-[#FFE566]'" class="text-xs font-black px-3 py-2 rounded-xl border transition-colors">Baca Selengkapnya &rarr;</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'landing'
})

const { isDark } = useTheme()

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


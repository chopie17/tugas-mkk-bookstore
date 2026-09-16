<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
    <div class="text-center mb-12">
      <span 
        :class="isDark ? 'bg-indigo-900/60 text-indigo-300 border-indigo-700' : 'bg-[#C8F53F] text-black border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'"
        class="px-3.5 py-1.5 rounded-full text-xs font-black border"
      >TENTANG KAMI</span>
      <h1 :class="isDark ? 'text-white' : 'text-slate-900'" class="text-3xl font-black mt-4 mb-4">Our Story - Cerita BookStore</h1>
      <p :class="isDark ? 'text-slate-400' : 'text-slate-700'" class="font-bold text-sm">Perjalanan kami menghadirkan platform toko buku online terbaik dan terpercaya.</p>
    </div>

    <div 
      :class="isDark ? 'bg-slate-900 border-slate-800 text-slate-200 shadow-xl' : 'bg-[#FFF8EC] border-3 border-black text-slate-900 shadow-[8px_8px_0px_#1A1A1A]'"
      class="rounded-3xl p-8 md:p-12 border space-y-6 leading-relaxed font-medium transition-colors duration-200"
    >
      <p>
        <strong>BookStore</strong> didirikan dengan semangat untuk mempermudah akses literatur dan buku-buku berkualitas bagi seluruh masyarakat Indonesia. Kami percaya bahwa membaca adalah jendela dunia dan kunci utama menuju kemajuan.
      </p>

      <p>
        Melalui platform digital yang dibangun dengan teknologi terbaru (Laravel 12 API & Nuxt 3), kami berkomitmen menyajikan pengalaman berbelanja yang cepat, aman, dan nyaman dari perangkat apa saja.
      </p>

      <div :class="isDark ? 'border-slate-800' : 'border-t-2 border-black'" class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-6 border-t">
        <div :class="isDark ? 'bg-slate-800 border-slate-700 text-slate-200' : 'bg-[#C8F53F] border-2 border-black text-slate-900 shadow-[3px_3px_0px_#1A1A1A]'" class="p-5 rounded-2xl border text-center">
          <div class="text-4xl mb-2">🎯</div>
          <h4 :class="isDark ? 'text-indigo-400' : 'text-black'" class="font-black text-sm mb-1">Misi Kami</h4>
          <p :class="isDark ? 'text-slate-400' : 'text-slate-900'" class="text-xs font-bold">Menyediakan koleksi buku terlengkap dengan jaminan kualitas terbaik.</p>
        </div>
        <div :class="isDark ? 'bg-slate-800 border-slate-700 text-slate-200' : 'bg-[#D4B8FF] border-2 border-black text-slate-900 shadow-[3px_3px_0px_#1A1A1A]'" class="p-5 rounded-2xl border text-center">
          <div class="text-4xl mb-2">⚡</div>
          <h4 :class="isDark ? 'text-indigo-400' : 'text-black'" class="font-black text-sm mb-1">Kemudahan Layanan</h4>
          <p :class="isDark ? 'text-slate-400' : 'text-slate-900'" class="text-xs font-bold">Proses pemesanan transparan dengan kode pesanan unik & invoice instan.</p>
        </div>
        <div :class="isDark ? 'bg-slate-800 border-slate-700 text-slate-200' : 'bg-[#FFD4A3] border-2 border-black text-slate-900 shadow-[3px_3px_0px_#1A1A1A]'" class="p-5 rounded-2xl border text-center">
          <div class="text-4xl mb-2">💬</div>
          <h4 :class="isDark ? 'text-indigo-400' : 'text-black'" class="font-black text-sm mb-1">Dukungan Responsif</h4>
          <p :class="isDark ? 'text-slate-400' : 'text-slate-900'" class="text-xs font-bold">Layanan live chat langsung dengan admin toko untuk konsultasi.</p>
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
</script>


<template>
  <div>
    <!-- Hero Section -->
    <section class="relative bg-gradient-to-br from-indigo-900 via-indigo-800 to-slate-900 text-white py-24 px-4 sm:px-6 lg:px-8 overflow-hidden">
      <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-indigo-500/20 via-transparent to-transparent"></div>
      <div class="max-w-7xl mx-auto relative z-10 grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
        <div>
          <span class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-indigo-500/20 text-indigo-300 text-xs font-semibold border border-indigo-400/30 mb-6 backdrop-blur-md">
            ✨ Platform Toko Buku Online Modern
          </span>
          <h1 class="text-4xl sm:text-5xl font-extrabold tracking-tight leading-tight mb-6">
            Temukan Buku Impianmu & Perluas Wawasanmu
          </h1>
          <p class="text-indigo-200 text-lg mb-8 leading-relaxed">
            Jelajahi ribuan koleksi buku fiksi, teknologi, bisnis, hingga sains dengan harga terbaik dan transaksi mudah.
          </p>
          <div class="flex flex-wrap gap-4">
            <NuxtLink to="/user/katalog" class="px-6 py-3.5 rounded-xl font-semibold text-white bg-indigo-600 hover:bg-indigo-500 shadow-lg shadow-indigo-500/30 transition-all hover:scale-105">
              📚 Jelajahi Katalog Buku
            </NuxtLink>
            <NuxtLink to="/our-story" class="px-6 py-3.5 rounded-xl font-semibold text-indigo-200 bg-white/10 hover:bg-white/20 border border-white/10 transition-all">
              Tentang Kami
            </NuxtLink>
          </div>
        </div>
        <div class="relative flex justify-center">
          <div class="w-72 h-96 bg-gradient-to-tr from-indigo-600 to-violet-400 rounded-3xl shadow-2xl rotate-3 hover:rotate-0 transition-transform duration-500 flex flex-col justify-between p-8 text-white border border-white/20">
            <div class="text-5xl">📖</div>
            <div>
              <h3 class="text-xl font-bold mb-2">BookStore Digital</h3>
              <p class="text-xs text-indigo-100">Solusi belanja buku cepat, aman, dan mudah dari mana saja.</p>
            </div>
            <div class="text-xs font-mono bg-white/20 px-3 py-1 rounded-full w-max">Nuxt 3 + Laravel 12</div>
          </div>
        </div>
      </div>
    </section>

    <!-- Categories Section -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div class="flex justify-between items-end mb-8">
        <div>
          <h2 class="text-2xl font-bold text-slate-900">Kategori Pilihan</h2>
          <p class="text-sm text-slate-500">Pilih kategori favoritmu untuk menemukan buku yang relevan</p>
        </div>
        <NuxtLink to="/user/katalog" class="text-sm font-semibold text-indigo-600 hover:text-indigo-700">Lihat Semua &rarr;</NuxtLink>
      </div>

      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-4">
        <div v-for="cat in categories" :key="cat.id" @click="navigateToCatalog(cat.id)" class="p-6 rounded-2xl bg-white border border-slate-200/80 shadow-sm hover:shadow-md hover:border-indigo-300 transition-all cursor-pointer group text-center">
          <div class="w-12 h-12 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center text-2xl mx-auto mb-3 group-hover:scale-110 transition-transform">
            📁
          </div>
          <h3 class="font-semibold text-slate-800 text-sm group-hover:text-indigo-600 transition-colors">{{ cat.nama_kategori }}</h3>
        </div>
      </div>
    </section>

    <!-- Featured Books Section -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <h2 class="text-2xl font-bold text-slate-900 mb-8">Buku Terbaru</h2>
      
      <div v-if="loading" class="text-center py-12 text-slate-500">Memuat buku...</div>
      <div v-else-if="books.length === 0" class="text-center py-12 text-slate-500">Belum ada buku tersedia.</div>
      <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6">
        <div v-for="book in books" :key="book.id" class="bg-white rounded-2xl border border-slate-200/80 shadow-sm hover:shadow-lg transition-all overflow-hidden flex flex-col justify-between">
          <div>
            <div class="h-48 bg-slate-100 flex items-center justify-center overflow-hidden relative">
              <img v-if="book.gambar" :src="book.gambar" :alt="book.nama_buku" class="w-full h-full object-cover" />
              <div v-else class="text-4xl">📕</div>
              <span class="absolute top-3 left-3 bg-indigo-600 text-white text-xs font-semibold px-2.5 py-1 rounded-full shadow-sm">
                {{ book.category_name || 'Buku' }}
              </span>
            </div>
            <div class="p-5">
              <h3 class="font-bold text-slate-900 text-base mb-1 line-clamp-1">{{ book.nama_buku }}</h3>
              <p class="text-xs text-slate-500 mb-3">Terbit: {{ book.tahun_terbit || '-' }}</p>
              <p class="text-xs text-slate-600 line-clamp-2 mb-4">{{ book.deskripsi || 'Tidak ada deskripsi' }}</p>
            </div>
          </div>
          <div class="p-5 pt-0 flex items-center justify-between border-t border-slate-100 pt-4">
            <div>
              <span class="text-xs text-slate-400 block">Harga</span>
              <span class="text-base font-extrabold text-indigo-600">Rp {{ formatNumber(book.harga_jual) }}</span>
            </div>
            <button @click="addToCart(book)" class="px-3.5 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-semibold transition-colors flex items-center gap-1.5 shadow-sm">
              <span>🛒</span> Tambah
            </button>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
const api = useApi()
const cartStore = useCartStore()

const categories = ref<any[]>([])
const books = ref<any[]>([])
const loading = ref(true)

const formatNumber = (val: number) => {
  return new Intl.NumberFormat('id-ID').format(val)
}

const navigateToCatalog = (catId: number) => {
  navigateTo(`/user/katalog?category_id=${catId}`)
}

const addToCart = (book: any) => {
  try {
    cartStore.addToCart(book, 1)
    alert(`'${book.nama_buku}' berhasil ditambahkan ke keranjang!`)
  } catch (err: any) {
    alert(err.message || 'Gagal menambahkan ke keranjang')
  }
}

onMounted(async () => {
  try {
    const catRes = await api.get('/api/categories')
    categories.value = catRes.data || []
    
    const bookRes = await api.get('/api/books')
    books.value = (bookRes.data || []).slice(0, 4)
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
})
</script>

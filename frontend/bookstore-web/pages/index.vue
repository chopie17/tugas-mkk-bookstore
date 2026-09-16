<template>
  <div>
    <!-- Hero Section -->
    <section 
      :class="isDark ? 'bg-slate-900 text-slate-100 border-slate-800 shadow-xl' : 'bg-[#FFF8EC] text-slate-900 border-2.5 border-[#1A1A1A] shadow-[6px_6px_0px_#1A1A1A]'"
      class="relative py-16 px-6 sm:px-10 rounded-3xl overflow-hidden mb-12 transition-colors duration-300"
    >
      <div class="max-w-7xl mx-auto relative z-10 grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
        <div>
          <span 
            :class="isDark ? 'bg-indigo-900/60 text-indigo-300 border-indigo-700/50' : 'bg-[#C8F53F] text-slate-900 border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'"
            class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-black border mb-6"
          >
            ✨ Platform Toko Buku Online Retro
          </span>
          <h1 :class="isDark ? 'text-white' : 'text-slate-900'" class="text-4xl sm:text-5xl font-black tracking-tight leading-tight mb-6">
            Temukan Buku Impianmu & Perluas Wawasanmu
          </h1>
          <p :class="isDark ? 'text-slate-300' : 'text-slate-800'" class="text-base font-bold mb-8 leading-relaxed">
            Jelajahi ribuan koleksi buku fiksi, teknologi, bisnis, hingga sains dengan harga terbaik dan transaksi mudah.
          </p>
          <div class="flex flex-wrap gap-4">
            <NuxtLink 
              to="/user/katalog" 
              :class="isDark ? 'bg-indigo-600 hover:bg-indigo-700 text-white shadow-lg shadow-indigo-600/30 border-indigo-500' : 'bg-[#C8F53F] text-black border-2.5 border-black shadow-[4px_4px_0px_#1A1A1A] hover:translate-x-[-2px] hover:translate-y-[-2px] active:translate-x-[2px] active:translate-y-[2px]'"
              class="px-6 py-3.5 rounded-2xl font-black transition-all border"
            >
              📚 Jelajahi Katalog Buku
            </NuxtLink>
            <NuxtLink 
              to="/our-story" 
              :class="isDark ? 'bg-slate-800 hover:bg-slate-700 text-slate-200 border-slate-700' : 'bg-[#FFD4A3] text-black border-2.5 border-black shadow-[4px_4px_0px_#1A1A1A] hover:translate-x-[-2px] hover:translate-y-[-2px] active:translate-x-[2px] active:translate-y-[2px]'"
              class="px-6 py-3.5 rounded-2xl font-black transition-all border"
            >
              Tentang Kami
            </NuxtLink>
          </div>
        </div>
        <div class="relative flex justify-center">
          <div 
            :class="isDark ? 'bg-slate-800 border-slate-700 text-slate-100 shadow-xl shadow-slate-950/50' : 'bg-[#D4B8FF] border-3 border-black text-slate-900 shadow-[8px_8px_0px_#1A1A1A]'"
            class="w-72 h-96 border rounded-3xl rotate-2 hover:rotate-0 transition-all duration-300 flex flex-col justify-between p-8"
          >
            <div class="text-6xl">📖</div>
            <div>
              <h3 class="text-2xl font-black mb-2" :class="isDark ? 'text-indigo-400' : 'text-slate-900'">BookStore Digital</h3>
              <p :class="isDark ? 'text-slate-400' : 'text-slate-800'" class="text-xs font-bold">Solusi belanja buku cepat, aman, dan mudah dari mana saja.</p>
            </div>
            <div 
              :class="isDark ? 'bg-indigo-900/80 text-indigo-200 border-indigo-700' : 'bg-[#C8F53F] text-slate-900 border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'"
              class="text-xs font-black border px-3 py-1.5 rounded-full w-max"
            >Nuxt 3 + Laravel 12</div>
          </div>
        </div>
      </div>
    </section>

    <!-- Categories Section -->
    <section class="max-w-7xl mx-auto px-2 py-8 mb-8">
      <div class="flex justify-between items-end mb-8">
        <div>
          <h2 
            :class="isDark ? 'bg-slate-800 text-indigo-400 border-slate-700' : 'bg-[#FFE566] text-slate-900 border-2 border-black shadow-[3px_3px_0px_#1A1A1A]'"
            class="text-2xl font-black px-3 py-1 inline-block rounded-xl border"
          >Kategori Pilihan</h2>
          <p :class="isDark ? 'text-slate-400' : 'text-slate-600'" class="text-xs font-bold mt-2">Pilih kategori favoritmu untuk menemukan buku yang relevan</p>
        </div>
        <NuxtLink 
          to="/user/katalog" 
          :class="isDark ? 'bg-slate-800 text-indigo-400 hover:bg-slate-700 border-slate-700' : 'bg-[#C8F53F] text-black border-2 border-black shadow-[2px_2px_0px_#1A1A1A] hover:translate-x-[-1px] active:translate-x-[1px]'"
          class="text-xs font-black px-3 py-1.5 rounded-xl border transition-all"
        >Lihat Semua &rarr;</NuxtLink>
      </div>

      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-4">
        <div 
          v-for="(cat, idx) in categories" 
          :key="cat.id" 
          @click="navigateToCatalog(cat.id)" 
          :class="[
            isDark 
              ? 'bg-slate-900 border-slate-800 text-slate-100 hover:bg-slate-800/80 hover:border-slate-700' 
              : (idx % 4 === 0 ? 'bg-[#FFF8EC]' : idx % 4 === 1 ? 'bg-[#D4B8FF]' : idx % 4 === 2 ? 'bg-[#FFD4A3]' : 'bg-[#A8E6CF]') + ' border-2.5 border-black shadow-[4px_4px_0px_#1A1A1A] hover:translate-x-[-2px] hover:translate-y-[-2px] active:translate-x-[2px] active:translate-y-[2px]'
          ]"
          class="p-6 rounded-2xl border transition-all cursor-pointer group text-center"
        >
          <div 
            :class="isDark ? 'bg-indigo-900/60 text-indigo-300 border-indigo-700' : 'bg-[#C8F53F] text-slate-900 border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'"
            class="w-12 h-12 rounded-xl border flex items-center justify-center text-2xl mx-auto mb-3 group-hover:scale-110 transition-transform"
          >
            📁
          </div>
          <h3 :class="isDark ? 'text-slate-200' : 'text-slate-900'" class="font-black text-sm">{{ cat.nama_kategori }}</h3>
        </div>
      </div>
    </section>

    <!-- Featured Books Section -->
    <section class="max-w-7xl mx-auto px-2 py-6">
      <h2 
        :class="isDark ? 'bg-slate-800 text-indigo-400 border-slate-700' : 'bg-[#FFB7B2] text-slate-900 border-2 border-black shadow-[3px_3px_0px_#1A1A1A]'"
        class="text-2xl font-black px-3 py-1 inline-block rounded-xl border mb-8"
      >Buku Terbaru</h2>
      
      <div v-if="loading" :class="isDark ? 'text-slate-400' : 'text-slate-600'" class="text-center py-12 font-black">Memuat buku...</div>
      <div v-else-if="books.length === 0" :class="isDark ? 'text-slate-400' : 'text-slate-600'" class="text-center py-12 font-black">Belum ada buku tersedia.</div>
      <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6">
        <div 
          v-for="book in books" 
          :key="book.id"
          @click="goToDetail(book)"
          :class="isDark ? 'bg-slate-900 border-slate-800 text-slate-100 hover:border-slate-700' : 'bg-[#FFF8EC] border-2.5 border-black shadow-[4px_4px_0px_#1A1A1A] hover:translate-x-[-2px] hover:translate-y-[-2px]'"
          class="rounded-2xl border transition-all overflow-hidden flex flex-col justify-between cursor-pointer group"
        >
          <div>
            <div :class="isDark ? 'bg-slate-950 border-slate-800' : 'bg-[#FAF7F0] border-b-2 border-black'" class="h-48 border-b flex items-center justify-center overflow-hidden relative">
              <img v-if="book.gambar" :src="book.gambar" :alt="book.nama_buku" class="w-full h-full object-cover" />
              <div v-else class="text-5xl">📕</div>
              <span 
                :class="isDark ? 'bg-indigo-900/80 text-indigo-200 border-indigo-700' : 'bg-[#C8F53F] text-black border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'"
                class="absolute top-3 left-3 border text-[10px] font-black px-2.5 py-1 rounded-full"
              >
                {{ book.category_name || 'Buku' }}
              </span>
            </div>
            <div class="p-5">
              <h3 :class="isDark ? 'text-white' : 'text-slate-900'" class="font-black text-base mb-1 line-clamp-1">{{ book.nama_buku }}</h3>
              <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-xs font-bold mb-2">Terbit: {{ book.tahun_terbit || '-' }}</p>
              <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-xs font-bold mb-3">
                Stok: 
                <span :class="book.stok > 0 ? (isDark ? 'text-emerald-400 bg-emerald-950/60 border-emerald-800 px-1 rounded border' : 'text-slate-900 bg-[#C8F53F] px-1 rounded border border-black') : 'text-rose-500 font-black'">{{ book.stok }}</span>
              </p>
              <p :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="text-xs font-medium line-clamp-2 mb-4">{{ book.deskripsi || 'Tidak ada deskripsi' }}</p>
            </div>
          </div>
          <div :class="isDark ? 'border-slate-800' : 'border-t-2 border-black'" class="p-5 pt-0 flex items-center justify-between border-t pt-4">
            <div>
              <span :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-[10px] font-black uppercase block">Harga</span>
              <span :class="isDark ? 'text-indigo-400' : 'text-black'" class="text-base font-black">Rp {{ formatNumber(book.harga_jual) }}</span>
            </div>
            <button 
              @click.stop="addToCart(book)" 
              :disabled="book.stok <= 0"
              :class="book.stok > 0 
                ? (isDark ? 'bg-indigo-600 hover:bg-indigo-700 text-white border-indigo-500' : 'bg-[#C8F53F] text-black border-2 border-black shadow-[2px_2px_0px_#1A1A1A] hover:translate-x-[-1px] hover:translate-y-[-1px] active:translate-x-[1px] active:translate-y-[1px]')
                : 'bg-slate-800 text-slate-500 border-slate-700 cursor-not-allowed'
              "
              class="px-4 py-2 rounded-xl font-black text-xs transition-all flex items-center gap-1.5 border disabled:opacity-50"
            >
              <span>🛒</span> 
              <span v-if="book.stok > 0">Tambah</span>
              <span v-else>Stok Habis</span>
            </button>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'landing',
  middleware: [
    async () => {
      const authStore = useAuthStore()
      if (!authStore.initialized) {
        await authStore.fetchUser()
      }
      if (authStore.isAuthenticated && authStore.isAdmin) {
        return navigateTo('/admin/kategori')
      }
    }
  ]
})

const router = useRouter()
const api = useApi()
const cartStore = useCartStore()
const { isDark } = useTheme()

const categories = ref<any[]>([])
const books = ref<any[]>([])
const loading = ref(true)

const formatNumber = (val: number) => {
  return new Intl.NumberFormat('id-ID').format(val)
}

const navigateToCatalog = (catId: number) => {
  navigateTo(`/user/katalog?category_id=${catId}`)
}

const goToDetail = (book: any) => {
  router.push(`/books/${book.id}`)
}

const authStore = useAuthStore()

const addToCart = async (book: any) => {
  const toast = useToast()
  if (!authStore.isAuthenticated) {
    toast.error('Silakan login terlebih dahulu untuk membeli buku!')
    navigateTo('/login')
    return
  }
  try {
    await cartStore.addToCart(book, 1)
    toast.success(`'${book.nama_buku}' berhasil ditambahkan ke keranjang!`)
  } catch (err: any) {
    toast.error(err.message || 'Gagal menambahkan ke keranjang')
  }
}

onMounted(async () => {
  try {
    const catRes = await api.get('/api/categories')
    categories.value = catRes.data || []
    
    const bookRes = await api.get('/api/books')
    let data = (bookRes.data || []).slice(0, 8) // Get first 8, then sort
    
    // Sort: stok > 0 first, then stok = 0 at the bottom
    data.sort((a: any, b: any) => {
      if (a.stok > 0 && b.stok <= 0) return -1
      if (a.stok <= 0 && b.stok > 0) return 1
      return 0
    })
    
    books.value = data
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
})
</script>


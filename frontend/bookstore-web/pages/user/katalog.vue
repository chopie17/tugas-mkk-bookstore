<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
      <div>
        <h1 :class="isDark ? 'text-white' : 'text-slate-900'" class="text-3xl font-extrabold">Katalog Buku</h1>
        <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-xs mt-1">Cari judul buku favoritmu atau filter berdasarkan kategori</p>
      </div>

      <!-- Search & Filter Controls -->
      <div class="flex flex-wrap items-center gap-3">
        <div class="relative w-full sm:w-64">
          <input 
            v-model="searchQuery" 
            @input="fetchBooks" 
            type="text" 
            placeholder="Cari judul buku..." 
            :class="isDark ? 'bg-slate-900 border-slate-700 text-white placeholder-slate-500 focus:border-indigo-500' : 'bg-white border-slate-300 text-slate-900 focus:border-indigo-500'"
            class="w-full pl-10 pr-4 py-2.5 text-xs rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none transition-colors" 
          />
          <span class="absolute left-3.5 top-2.5 text-sm text-slate-400">🔍</span>
        </div>

        <select 
          v-model="selectedCategory" 
          @change="fetchBooks" 
          :class="isDark ? 'bg-slate-900 border-slate-700 text-white' : 'bg-white border-slate-300 text-slate-900'"
          class="px-3.5 py-2.5 text-xs rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none transition-colors"
        >
          <option value="">Semua Kategori</option>
          <option v-for="cat in categories" :key="cat.id" :value="cat.id" :class="isDark ? 'bg-slate-900 text-white' : 'bg-white text-slate-900'">{{ cat.nama_kategori }}</option>
        </select>
      </div>
    </div>

    <!-- Books Grid -->
    <div v-if="loading" :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-center py-20">Memuat buku...</div>
    <div v-else-if="books.length === 0" :class="isDark ? 'bg-slate-900 border-slate-800' : 'bg-white border-slate-200/80'" class="text-center py-20 rounded-3xl border">
      <div class="text-4xl mb-2">🔍</div>
      <h3 :class="isDark ? 'text-slate-200' : 'text-slate-700'" class="font-bold">Buku tidak ditemukan</h3>
      <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-xs mt-1">Coba kata kunci pencarian atau kategori lain.</p>
    </div>
    <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
      <div 
        v-for="book in books" 
        :key="book.id" 
        :class="isDark ? 'bg-slate-900 border-slate-800 hover:border-slate-700 shadow-slate-950/50' : 'bg-white border-slate-200/80 shadow-sm'"
        class="rounded-2xl border hover:shadow-xl transition-all overflow-hidden flex flex-col justify-between group"
      >
        <div>
          <div :class="isDark ? 'bg-slate-950' : 'bg-slate-100'" class="h-52 flex items-center justify-center overflow-hidden relative">
            <img v-if="book.gambar" :src="book.gambar" :alt="book.nama_buku" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" />
            <div v-else class="text-5xl">📕</div>
            <span class="absolute top-3 left-3 bg-indigo-600 text-white text-[10px] font-bold px-2.5 py-1 rounded-full shadow-sm">
              {{ book.category_name || 'Buku' }}
            </span>
          </div>

          <div class="p-5">
            <h3 :class="isDark ? 'text-white group-hover:text-indigo-400' : 'text-slate-900 group-hover:text-indigo-600'" class="font-bold text-base mb-1 line-clamp-1 transition-colors">{{ book.nama_buku }}</h3>
            <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-[11px] mb-2">Tahun Terbit: {{ book.tahun_terbit || '-' }} • Stok: <span :class="book.stok > 0 ? 'text-emerald-500 font-semibold' : 'text-rose-500 font-semibold'">{{ book.stok }}</span></p>
            <p :class="isDark ? 'text-slate-300' : 'text-slate-600'" class="text-xs line-clamp-2 mb-4">{{ book.deskripsi || 'Tidak ada deskripsi' }}</p>
          </div>
        </div>

        <div :class="isDark ? 'border-slate-800' : 'border-slate-100'" class="p-5 pt-0 border-t flex items-center justify-between pt-4">
          <div>
            <span :class="isDark ? 'text-slate-500' : 'text-slate-400'" class="text-[10px] block uppercase font-semibold">Harga</span>
            <span class="text-base font-extrabold text-indigo-500">Rp {{ formatNumber(book.harga_jual) }}</span>
          </div>

          <button @click="addToCart(book)" :disabled="book.stok <= 0" class="px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-700 disabled:bg-slate-700 disabled:text-slate-500 text-white text-xs font-semibold transition-colors flex items-center gap-1.5 shadow-sm">
            <span>🛒</span>
            <span v-if="book.stok > 0">Beli</span>
            <span v-else>Habis</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const api = useApi()
const cartStore = useCartStore()
const { isDark } = useTheme()

const searchQuery = ref('')
const selectedCategory = ref<string | number>(route.query.category_id ? String(route.query.category_id) : '')
const categories = ref<any[]>([])
const books = ref<any[]>([])
const loading = ref(true)

const formatNumber = (val: number) => {
  return new Intl.NumberFormat('id-ID').format(val)
}

const fetchBooks = async () => {
  loading.value = true
  try {
    const params: any = {}
    if (searchQuery.value) params.search = searchQuery.value
    if (selectedCategory.value) params.category_id = selectedCategory.value

    const res = await api.get('/api/books', { params })
    books.value = res.data || []
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

const addToCart = async (book: any) => {
  try {
    await cartStore.addToCart(book, 1)
    alert(`'${book.nama_buku}' ditambahkan ke keranjang.`)
  } catch (err: any) {
    alert(err.message || 'Gagal menambahkan ke keranjang.')
  }
}

onMounted(async () => {
  try {
    const catRes = await api.get('/api/categories')
    categories.value = catRes.data || []
  } catch (e) {}

  await fetchBooks()
})
</script>

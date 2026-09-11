<template>
  <div class="max-w-4xl mx-auto px-4 py-10">
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 :class="isDark ? 'text-white' : 'text-slate-900'" class="text-3xl font-extrabold">Keranjang Belanja</h1>
        <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-xs mt-1">Periksa kembali daftar buku yang akan Anda beli</p>
      </div>

      <button v-if="cartStore.items.length > 0" @click="cartStore.clearCart()" class="text-xs font-semibold text-rose-500 hover:text-rose-600">
        Kosongkan Keranjang
      </button>
    </div>

    <div v-if="cartStore.items.length === 0" :class="isDark ? 'bg-slate-900 border-slate-800' : 'bg-white border-slate-200/80'" class="text-center py-20 rounded-3xl border shadow-sm">
      <div class="text-5xl mb-3">🛒</div>
      <h3 :class="isDark ? 'text-slate-200' : 'text-slate-700'" class="font-bold text-lg">Keranjang Belanja Masih Kosong</h3>
      <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-xs mt-1 mb-6">Jelajahi katalog kami untuk menemukan buku favoritmu.</p>
      <NuxtLink to="/user/katalog" class="px-6 py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-semibold shadow-md shadow-indigo-500/20">
        Ke Katalog Buku &rarr;
      </NuxtLink>
    </div>

    <div v-else class="grid grid-cols-1 md:grid-cols-3 gap-8">
      <!-- Item List -->
      <div class="md:col-span-2 space-y-4">
        <div 
          v-for="item in cartStore.items" 
          :key="item.book_id" 
          :class="isDark ? 'bg-slate-900 border-slate-800' : 'bg-white border-slate-200/80'"
          class="p-4 rounded-2xl border shadow-sm flex items-center justify-between gap-4"
        >
          <div class="flex items-center gap-4">
            <div :class="isDark ? 'bg-slate-950' : 'bg-slate-100'" class="w-16 h-20 rounded-xl overflow-hidden flex items-center justify-center shrink-0">
              <img v-if="item.gambar" :src="item.gambar" :alt="item.nama_buku" class="w-full h-full object-cover" />
              <span v-else class="text-2xl">📕</span>
            </div>
            <div>
              <h4 :class="isDark ? 'text-white' : 'text-slate-900'" class="font-bold text-sm line-clamp-1">{{ item.nama_buku }}</h4>
              <p class="text-xs font-semibold text-indigo-500 mt-1">Rp {{ formatNumber(item.harga_jual) }}</p>
              <p :class="isDark ? 'text-slate-400' : 'text-slate-400'" class="text-[10px]">Sisa stok: {{ item.stok }}</p>
            </div>
          </div>

          <!-- Qty controls -->
          <div class="flex items-center gap-3">
            <div :class="isDark ? 'border-slate-700 bg-slate-950' : 'border-slate-200 bg-slate-50'" class="flex items-center border rounded-xl overflow-hidden">
              <button @click="updateQty(item.book_id, item.qty - 1)" :class="isDark ? 'text-slate-300 hover:bg-slate-800' : 'text-slate-600 hover:bg-slate-200'" class="px-3 py-1 text-xs font-bold">-</button>
              <span :class="isDark ? 'text-white' : 'text-slate-800'" class="px-3 py-1 text-xs font-bold">{{ item.qty }}</span>
              <button @click="updateQty(item.book_id, item.qty + 1)" :class="isDark ? 'text-slate-300 hover:bg-slate-800' : 'text-slate-600 hover:bg-slate-200'" class="px-3 py-1 text-xs font-bold">+</button>
            </div>

            <button @click="cartStore.removeFromCart(item.book_id)" class="text-rose-500 hover:text-rose-700 text-sm p-1">
              🗑️
            </button>
          </div>
        </div>
      </div>

      <!-- Order Summary Card -->
      <div :class="isDark ? 'bg-slate-900 border-slate-800' : 'bg-white border-slate-200/80'" class="p-6 rounded-3xl border shadow-sm h-max space-y-4">
        <h3 :class="isDark ? 'text-white border-slate-800' : 'text-slate-900 border-slate-100'" class="font-bold text-base border-b pb-3">Ringkasan Pesanan</h3>

        <div :class="isDark ? 'text-slate-300' : 'text-slate-600'" class="flex justify-between text-xs">
          <span>Total Item</span>
          <span class="font-semibold">{{ cartStore.totalItems }} buku</span>
        </div>

        <div :class="isDark ? 'text-white border-slate-800' : 'text-slate-900 border-slate-100'" class="flex justify-between text-sm font-bold border-t pt-3">
          <span>Total Harga</span>
          <span class="text-indigo-500">Rp {{ formatNumber(cartStore.totalPrice) }}</span>
        </div>

        <button @click="checkout" :disabled="loading" class="w-full py-3.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-sm shadow-md shadow-indigo-500/20 transition-all disabled:opacity-50 mt-4">
          <span v-if="loading">Memproses Checkout...</span>
          <span v-else>Buat Pesanan Sekarang &rarr;</span>
        </button>

        <p :class="isDark ? 'text-slate-500' : 'text-slate-400'" class="text-[10px] text-center leading-relaxed">
          Kode pesanan akan otomatis di-generate oleh sistem backend (Format A021).
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: 'auth'
})

const api = useApi()
const cartStore = useCartStore()
const { isDark } = useTheme()
const loading = ref(false)

const formatNumber = (val: number) => {
  return new Intl.NumberFormat('id-ID').format(val)
}

const updateQty = async (bookId: number, qty: number) => {
  try {
    await cartStore.updateQty(bookId, qty)
  } catch (err: any) {
    alert(err.message || 'Stok tidak mencukupi')
  }
}

onMounted(async () => {
  await cartStore.fetchCart()
})

const checkout = async () => {
  if (cartStore.items.length === 0) return

  loading.value = true
  try {
    const payload = {
      items: cartStore.items.map(i => ({
        book_id: i.book_id,
        qty: i.qty
      }))
    }

    const res = await api.post<{ message: string; data: any }>('/api/orders', payload)
    cartStore.clearCart()
    alert(res.message || 'Pesanan berhasil dibuat!')
    navigateTo('/user/riwayat')
  } catch (err: any) {
    alert(err.data?.message || 'Gagal memproses checkout.')
  } finally {
    loading.value = false
  }
}
</script>

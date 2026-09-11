<template>
  <div class="space-y-6">
    <!-- Top Filter Bar matching mockup design -->
    <div class="flex flex-col sm:flex-row items-center justify-between gap-4">
      <!-- Search Box inside content -->
      <div class="relative w-full sm:w-96">
        <input 
          v-model="searchQuery" 
          type="text" 
          placeholder="Search..." 
          class="w-full pl-10 pr-4 py-2.5 rounded-full border-2 border-slate-700 bg-white text-sm font-medium shadow-sm outline-none focus:ring-2 focus:ring-indigo-400"
        />
        <LucideSearch class="w-5 h-5 text-slate-700 absolute left-3.5 top-3" />
      </div>

      <!-- Year / Date Picker matching mockup -->
      <div class="flex items-center gap-3 bg-indigo-100/80 border-2 border-slate-700 rounded-xl px-4 py-2 text-sm font-extrabold text-slate-800 shadow-sm">
        <input 
          v-model="filterYear" 
          type="number" 
          placeholder="2026" 
          class="bg-transparent text-center w-20 outline-none font-bold text-slate-900"
          @change="fetchReport"
        />
        <LucideCalendar class="w-5 h-5 text-indigo-700" />
      </div>
    </div>

    <!-- Table Container matching mockup solid grid borders -->
    <div class="bg-white rounded-2xl border-2 border-slate-800 overflow-hidden shadow-sm">
      <div v-if="loading" class="text-center py-12 text-sm text-slate-500 font-semibold">
        Memuat laporan...
      </div>
      <div v-else-if="filteredRows.length === 0" class="text-center py-12 text-sm text-slate-500 font-semibold">
        Tidak ada data transaksi.
      </div>
      <div v-else class="overflow-x-auto">
        <table class="w-full text-center border-collapse">
          <thead>
            <tr class="bg-slate-100 text-slate-900 font-black text-sm border-b-2 border-slate-800">
              <th class="p-4 border-r-2 border-slate-800">Kode Pesanan</th>
              <th class="p-4 border-r-2 border-slate-800">Judul Buku</th>
              <th class="p-4 border-r-2 border-slate-800">Tanggal Pembelian</th>
              <th class="p-4 border-r-2 border-slate-800">Jumlah Pesan</th>
              <th class="p-4">total Harga</th>
            </tr>
          </thead>
          <tbody class="divide-y-2 divide-slate-800 text-xs font-semibold text-slate-900">
            <tr 
              v-for="(item, idx) in filteredRows" 
              :key="idx" 
              class="hover:bg-slate-50 transition-colors"
            >
              <td class="p-4 border-r-2 border-slate-800 font-bold uppercase">{{ item.kode_pesanan }}</td>
              <td class="p-4 border-r-2 border-slate-800 text-left px-6">{{ item.judul_buku }}</td>
              <td class="p-4 border-r-2 border-slate-800">{{ item.tanggal }}</td>
              <td class="p-4 border-r-2 border-slate-800 font-bold">{{ item.jumlah }}</td>
              <td class="p-4 font-bold">Rp. {{ formatPrice(item.total_harga) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Download Action Button matching mockup -->
    <div class="flex justify-end pt-2">
      <a 
        :href="pdfExportUrl" 
        target="_blank" 
        class="bg-gradient-to-r from-emerald-200 via-sky-200 to-indigo-200 hover:from-emerald-300 hover:to-indigo-300 border-2 border-slate-800 text-slate-900 font-black text-lg px-10 py-3 rounded-2xl shadow-md transition-transform hover:scale-105 active:scale-95 inline-flex items-center gap-2"
      >
        Download
      </a>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Search as LucideSearch, Calendar as LucideCalendar } from 'lucide-vue-next'

definePageMeta({
  middleware: 'admin'
})

const api = useApi()
const loading = ref(true)
const searchQuery = ref('')
const filterYear = ref(new Date().getFullYear())

const orders = ref<any[]>([])

const formatPrice = (val: number) => {
  return new Intl.NumberFormat('id-ID').format(val || 0)
}

const pdfExportUrl = computed(() => {
  let url = `${api.apiBase}/api/admin/reports/export-pdf`
  if (filterYear.value) {
    url += `?year=${filterYear.value}`
  }
  return url
})

const fetchReport = async () => {
  loading.value = true
  try {
    const res = await api.get('/api/admin/reports', {
      params: { year: filterYear.value }
    })
    orders.value = res.orders || []
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

// Flatten order items for table display matching mockup columns
const tableRows = computed(() => {
  const rows: any[] = []
  orders.value.forEach(order => {
    if (order.items && order.items.length > 0) {
      order.items.forEach((item: any) => {
        rows.push({
          kode_pesanan: order.kode_pesanan,
          judul_buku: item.buku?.judul || item.judul_buku || 'Buku',
          tanggal: order.created_at ? new Date(order.created_at).toLocaleDateString('id-ID') : '21/4/2026',
          jumlah: item.jumlah,
          total_harga: item.subtotal || (item.jumlah * item.harga_satuan)
        })
      })
    } else {
      rows.push({
        kode_pesanan: order.kode_pesanan,
        judul_buku: order.pelanggan ? `Order oleh ${order.pelanggan}` : 'Detail Buku',
        tanggal: order.created_at ? new Date(order.created_at).toLocaleDateString('id-ID') : '21/4/2026',
        jumlah: order.total_items || 1,
        total_harga: order.total_harga
      })
    }
  })
  return rows
})

const filteredRows = computed(() => {
  if (!searchQuery.value.trim()) return tableRows.value
  const q = searchQuery.value.toLowerCase()
  return tableRows.value.filter(r => 
    r.kode_pesanan.toLowerCase().includes(q) || 
    r.judul_buku.toLowerCase().includes(q)
  )
})

onMounted(fetchReport)
</script>

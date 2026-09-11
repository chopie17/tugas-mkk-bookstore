<template>
  <div class="space-y-6">
    <!-- Search / USB Scanner / Camera Scanner Header -->
    <div 
      :class="isDark ? 'bg-slate-900 border-slate-800 text-slate-100' : 'bg-white border-slate-800 text-slate-900'"
      class="p-5 rounded-3xl border-2 shadow-sm flex flex-col md:flex-row items-center justify-between gap-4 transition-colors duration-300"
    >
      <div class="flex items-center gap-2 w-full md:w-auto flex-1">
        <div class="relative w-full max-w-md">
          <input 
            ref="scannerInput"
            v-model="scanQuery" 
            type="text" 
            placeholder="Scan QR Code / Masukkan Kode (A021)..." 
            :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500 focus:bg-slate-900' : 'bg-slate-50 border-slate-800 text-slate-900 focus:bg-white'"
            class="w-full pl-10 pr-4 py-3 rounded-full border-2 text-sm font-extrabold focus:ring-2 focus:ring-indigo-500 outline-none transition-colors"
            @keyup.enter="handleScanSubmit"
          />
          <LucideQrCode class="w-5 h-5 text-indigo-500 absolute left-3.5 top-3.5" />
        </div>
        <button 
          @click="startCameraScanner" 
          class="px-4 py-3 bg-indigo-600 hover:bg-indigo-700 text-white rounded-full font-black text-xs border-2 border-slate-900 shadow-md flex items-center gap-1.5 whitespace-nowrap transition-transform active:scale-95"
        >
          📷 Scan Kamera HP / Web
        </button>
      </div>

      <div class="flex items-center gap-2 flex-wrap">
        <span class="text-xs font-black uppercase" :class="isDark ? 'text-slate-400' : 'text-slate-700'">Status:</span>
        <button @click="filterStatus = ''" :class="filterStatus === '' ? 'bg-indigo-600 text-white' : (isDark ? 'bg-slate-800 text-slate-300' : 'bg-slate-100 text-slate-700')" class="px-3.5 py-1.5 text-xs font-black rounded-xl border-2 border-slate-800 transition-colors">Semua</button>
        <button @click="filterStatus = 'pending'" :class="filterStatus === 'pending' ? 'bg-amber-500 text-slate-950' : (isDark ? 'bg-slate-800 text-slate-300' : 'bg-slate-100 text-slate-700')" class="px-3.5 py-1.5 text-xs font-black rounded-xl border-2 border-slate-800 transition-colors">Pending</button>
        <button @click="filterStatus = 'confirmed'" :class="filterStatus === 'confirmed' ? 'bg-sky-500 text-slate-950' : (isDark ? 'bg-slate-800 text-slate-300' : 'bg-slate-100 text-slate-700')" class="px-3.5 py-1.5 text-xs font-black rounded-xl border-2 border-slate-800 transition-colors">Confirmed</button>
        <button @click="filterStatus = 'completed'" :class="filterStatus === 'completed' ? 'bg-emerald-500 text-slate-950' : (isDark ? 'bg-slate-800 text-slate-300' : 'bg-slate-100 text-slate-700')" class="px-3.5 py-1.5 text-xs font-black rounded-xl border-2 border-slate-800 transition-colors">Completed</button>
      </div>
    </div>

    <!-- Modal Scanner Kamera Web / HP -->
    <div v-if="showCameraModal" class="fixed inset-0 bg-slate-950/85 backdrop-blur-md z-50 flex items-center justify-center p-4">
      <div 
        :class="isDark ? 'bg-slate-900 border-slate-700 text-white' : 'bg-white border-slate-900 text-slate-900'"
        class="rounded-3xl p-6 max-w-md w-full shadow-2xl border-4 space-y-4 text-center relative overflow-hidden"
      >
        <div class="flex justify-between items-center border-b-2 border-slate-800 pb-3">
          <h3 class="font-black text-lg flex items-center gap-2">
            📷 Pemindai Kamera QR Code
          </h3>
          <button @click="stopCameraScanner" :class="isDark ? 'bg-slate-800 text-slate-300 hover:text-white' : 'bg-slate-100 text-slate-700 hover:text-slate-900'" class="text-xs font-black px-3 py-1.5 rounded-xl border border-slate-700">
            ✕ Tutup Kamera
          </button>
        </div>

        <div class="relative aspect-square w-full bg-slate-950 rounded-2xl overflow-hidden border-2 border-slate-800 flex items-center justify-center">
          <video ref="videoRef" class="w-full h-full object-cover"></video>
          <canvas ref="canvasRef" class="hidden"></canvas>
          <div class="absolute inset-0 border-4 border-dashed border-emerald-400/80 m-10 rounded-2xl pointer-events-none animate-pulse flex items-center justify-center">
            <span class="text-white text-xs font-extrabold bg-slate-900/90 px-3 py-1 rounded-full border border-emerald-400">Posisikan QR di dalam Kotak</span>
          </div>
        </div>

        <p class="text-xs font-extrabold" :class="isDark ? 'text-slate-400' : 'text-slate-600'">Arahkan kamera ke QR Code di layar HP pembeli untuk memindai otomatis.</p>
      </div>
    </div>

    <!-- Banner Notifikasi Scan Berhasil -->
    <div v-if="scanSuccessBanner" class="bg-emerald-600 border-4 border-slate-900 text-white p-5 rounded-3xl shadow-lg flex items-center justify-between gap-4 animate-bounce">
      <div class="flex items-center gap-3">
        <span class="text-3xl">✅</span>
        <div>
          <h3 class="font-black text-lg tracking-wide uppercase text-yellow-300">Scan QR Code Berhasil & Dicatat di Admin!</h3>
          <p class="text-xs font-bold">
            Kode Pesanan: <span class="font-mono underline text-white font-black">{{ scanSuccessCode }}</span>. Transaksi terdeteksi! Mohon proses pembayaran / konfirmasi dan berikan Struk atau Invoice langsung kepada pelanggan.
          </p>
        </div>
      </div>
      <button @click="scanSuccessBanner = false" class="bg-slate-900 text-white hover:bg-slate-800 font-extrabold text-xs px-3.5 py-2 rounded-xl border border-white">
        ✕ Tutup Notifikasi
      </button>
    </div>

    <!-- Scanned / Active Selected Order View -->
    <div v-if="selectedOrder" id="selected-order-section" class="order-card space-y-4">
      <div 
        :class="isDark ? 'bg-slate-900 border-slate-700 text-slate-100' : 'bg-gradient-to-r from-emerald-100 via-sky-100 to-indigo-200 border-slate-900 text-slate-900'"
        class="border-2 rounded-3xl p-6 shadow-md relative transition-colors duration-300"
      >
        <div class="flex items-center justify-between mb-4">
          <div>
            <h2 class="text-2xl font-black font-serif tracking-tight" :class="isDark ? 'text-white' : 'text-slate-900'">
              Kode Pesanan : <span class="font-mono text-indigo-400 uppercase">{{ selectedOrder.kode_pesanan }}</span>
            </h2>
            <p class="text-xs font-bold" :class="isDark ? 'text-slate-400' : 'text-slate-700'">Pelanggan: {{ selectedOrder.user_name || selectedOrder.pelanggan || 'User' }}</p>
          </div>
          <div class="flex items-center gap-2">
            <span :class="getStatusBadgeClass(selectedOrder.status)" class="text-xs font-black uppercase px-3 py-1 rounded-full border">
              {{ selectedOrder.status }}
            </span>
            <button @click="selectedOrder = null" :class="isDark ? 'bg-slate-800 text-slate-300 hover:text-white border-slate-700' : 'bg-white/60 text-slate-700 hover:text-slate-900 border-slate-300'" class="text-xs font-bold px-2 py-1 rounded-lg border">
              ✕ Tutup
            </button>
          </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-4 gap-6 items-center">
          <!-- Table Section -->
          <div class="lg:col-span-3 overflow-x-auto">
            <table 
              :class="isDark ? 'bg-slate-950 border-slate-800 text-slate-200' : 'bg-white/80 border-slate-900 text-slate-900'"
              class="w-full text-center border-collapse border-2"
            >
              <thead>
                <tr :class="isDark ? 'bg-slate-800 text-slate-200 border-slate-700' : 'bg-slate-200 text-slate-900 border-slate-900'" class="font-black text-xs border-b-2">
                  <th class="p-2 border-r-2 border-slate-700">Judul Buku</th>
                  <th class="p-2 border-r-2 border-slate-700">Tanggal Pembelian</th>
                  <th class="p-2 border-r-2 border-slate-700">Jumlah Pesanan</th>
                  <th class="p-2 border-r-2 border-slate-700">Harga Satuan</th>
                  <th class="p-2">Total Harga</th>
                </tr>
              </thead>
              <tbody class="divide-y-2 divide-slate-800 text-xs font-bold">
                <tr v-for="detail in (selectedOrder.details || selectedOrder.items || [])" :key="detail.id">
                  <td class="p-2.5 border-r-2 border-slate-800 text-left px-4 font-extrabold">{{ detail.buku?.judul || detail.nama_buku }}</td>
                  <td class="p-2.5 border-r-2 border-slate-800">{{ formatDate(selectedOrder.created_at) }}</td>
                  <td class="p-2.5 border-r-2 border-slate-800 font-extrabold">{{ detail.qty }}</td>
                  <td class="p-2.5 border-r-2 border-slate-800">Rp.{{ formatPrice(detail.harga_satuan) }}</td>
                  <td class="p-2.5 font-extrabold">Rp.{{ formatPrice(detail.subtotal) }}</td>
                </tr>
                <tr :class="isDark ? 'bg-slate-800 border-slate-700 text-white' : 'bg-slate-200 border-slate-900 text-slate-900'" class="font-black text-sm border-t-2">
                  <td colspan="5" class="p-3 text-center">
                    Total Harga : Rp. {{ formatPrice(selectedOrder.total_harga) }}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- QR Code Display -->
          <div :class="isDark ? 'bg-slate-950 border-slate-800' : 'bg-white/90 border-slate-900'" class="lg:col-span-1 flex flex-col items-center justify-center p-2 rounded-2xl border-2 shadow-sm">
            <QrCodeDisplay :value="selectedOrder.kode_pesanan" :size="140" show-label />
            <p class="text-[10px] text-emerald-400 font-black text-center mt-1">✔ QR Code Terverifikasi</p>
          </div>
        </div>
      </div>

      <!-- Action Row for Cashier -->
      <div class="flex flex-col sm:flex-row gap-3 print:hidden">
        <button 
          v-if="selectedOrder.status === 'pending'"
          @click="confirmOrder(selectedOrder)"
          class="flex-1 bg-sky-600 hover:bg-sky-700 border-2 border-slate-900 text-white font-extrabold text-base py-3 rounded-2xl shadow-md transition-all"
        >
          ✔ Konfirmasi Pesanan
        </button>

        <button 
          v-if="selectedOrder.status === 'confirmed'"
          @click="openPayModal(selectedOrder)"
          class="flex-1 bg-emerald-600 hover:bg-emerald-700 border-2 border-slate-900 text-white font-extrabold text-base py-3 rounded-2xl shadow-md transition-all"
        >
          💵 Bayar Uang Tunai
        </button>

        <button 
          @click="printReceipt" 
          :class="isDark ? 'bg-slate-800 text-white border-slate-700 hover:bg-slate-700' : 'bg-slate-200 text-slate-900 border-slate-900 hover:bg-slate-300'"
          class="flex-1 border-2 font-black text-base py-3 rounded-2xl shadow-md transition-all hover:scale-[1.01]"
        >
          🖨️ Print Struk Kasir
        </button>

        <button 
          @click="downloadInvoicePdf(selectedOrder.id)" 
          class="flex-1 bg-indigo-600 hover:bg-indigo-700 border-2 border-slate-900 text-white font-black text-base py-3 rounded-2xl shadow-md transition-all hover:scale-[1.01]"
        >
          📄 Unduh Invoice PDF
        </button>
      </div>
    </div>

    <!-- Orders Grid Table -->
    <div :class="isDark ? 'bg-slate-900 border-slate-800 text-slate-100' : 'bg-white border-slate-800 text-slate-900'" class="rounded-3xl border-2 overflow-hidden shadow-sm">
      <div v-if="loading" class="text-center py-16 text-slate-500 font-extrabold">Memuat daftar pesanan...</div>
      <div v-else-if="filteredOrders.length === 0" class="text-center py-16 text-slate-500 font-extrabold">
        Tidak ada pesanan ditemukan.
      </div>
      <div v-else class="overflow-x-auto">
        <table class="w-full text-center border-collapse">
          <thead>
            <tr :class="isDark ? 'bg-slate-800 text-slate-200 border-slate-700' : 'bg-slate-100 text-slate-900 border-slate-800'" class="font-black text-xs border-b-2">
              <th class="p-3 border-r-2 border-slate-800">Kode Pesanan</th>
              <th class="p-3 border-r-2 border-slate-800">Pelanggan</th>
              <th class="p-3 border-r-2 border-slate-800">Tanggal</th>
              <th class="p-3 border-r-2 border-slate-800">Total Tagihan</th>
              <th class="p-3 border-r-2 border-slate-800">Status</th>
              <th class="p-3">Aksi</th>
            </tr>
          </thead>
          <tbody class="divide-y-2 divide-slate-800 text-xs font-bold">
            <tr v-for="order in filteredOrders" :key="order.id" :class="isDark ? 'hover:bg-slate-800/60' : 'hover:bg-slate-50'" class="transition-colors">
              <td class="p-3 border-r-2 border-slate-800 font-mono font-black text-indigo-400 uppercase">{{ order.kode_pesanan }}</td>
              <td class="p-3 border-r-2 border-slate-800 font-extrabold">{{ order.user_name || order.pelanggan || 'User' }}</td>
              <td class="p-3 border-r-2 border-slate-800">{{ formatDate(order.created_at) }}</td>
              <td class="p-3 border-r-2 border-slate-800 font-extrabold text-indigo-400">Rp. {{ formatPrice(order.total_harga) }}</td>
              <td class="p-3 border-r-2 border-slate-800">
                <span :class="getStatusBadgeClass(order.status)" class="text-[10px] font-black uppercase px-2.5 py-0.5 rounded-full border">
                  {{ order.status }}
                </span>
              </td>
              <td class="p-3 flex justify-center gap-2">
                <button @click="selectOrder(order)" :class="isDark ? 'bg-slate-800 hover:bg-slate-700 text-indigo-300 border-slate-700' : 'bg-indigo-100 hover:bg-indigo-200 text-indigo-950 border-slate-800'" class="px-3 py-1 border rounded-xl font-bold text-xs">
                  👁️ Lihat Detail & Struk
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal Pembayaran Tunai -->
    <div v-if="showPayModal" class="fixed inset-0 bg-slate-950/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div :class="isDark ? 'bg-slate-900 border-slate-700 text-slate-100' : 'bg-white border-slate-900 text-slate-900'" class="rounded-3xl p-6 max-w-md w-full shadow-2xl border-2 space-y-4">
        <div class="border-b-2 border-slate-800 pb-3">
          <h3 class="font-black text-lg">Kasir Pembayaran Tunai</h3>
          <p class="text-xs font-bold text-slate-400">Kode Pesanan: <span class="font-mono font-black text-indigo-400 uppercase">{{ activePayOrder?.kode_pesanan }}</span></p>
        </div>

        <div :class="isDark ? 'bg-slate-950 border-slate-800' : 'bg-indigo-100/70 border-slate-800'" class="p-4 rounded-2xl border-2 text-center">
          <span class="text-xs text-indigo-400 block font-bold">Total Tagihan Harus Dibayar</span>
          <span class="text-2xl font-black text-indigo-400">Rp. {{ formatPrice(activePayOrder?.total_harga || 0) }}</span>
        </div>

        <form @submit.prevent="processPayment" class="space-y-4">
          <div>
            <label class="block text-xs font-black mb-1" :class="isDark ? 'text-slate-300' : 'text-slate-800'">Nominal Uang Tunai / Cash (Rp)</label>
            <input 
              v-model.number="cashInput" 
              type="number" 
              required 
              :min="activePayOrder?.total_harga" 
              :class="isDark ? 'bg-slate-950 border-slate-700 text-white focus:ring-emerald-500' : 'bg-white border-slate-800 text-slate-900 focus:ring-emerald-500'"
              class="w-full px-4 py-3 text-base font-black rounded-xl border-2 focus:ring-2 outline-none" 
              placeholder="100000" 
            />
          </div>

          <div :class="isDark ? 'bg-slate-950 border-slate-800' : 'bg-slate-100 border-slate-800'" class="p-3.5 border-2 rounded-xl flex justify-between items-center text-xs">
            <span class="font-black">Uang Kembalian:</span>
            <span :class="computedKembalian >= 0 ? 'text-emerald-400 font-black text-base' : 'text-rose-400 font-black'">
              Rp. {{ formatPrice(computedKembalian) }}
            </span>
          </div>

          <div class="flex justify-end gap-3 pt-2">
            <button type="button" @click="showPayModal = false" :class="isDark ? 'bg-slate-800 text-slate-300 hover:bg-slate-700 border-slate-700' : 'bg-slate-100 text-slate-700 hover:bg-slate-200 border-slate-300'" class="px-4 py-2 text-xs font-bold rounded-xl transition-colors border">
              Batal
            </button>
            <button type="submit" :disabled="submittingPay || computedKembalian < 0" class="px-5 py-2.5 text-xs font-black text-white bg-emerald-600 hover:bg-emerald-700 border-2 border-slate-900 rounded-xl shadow-md transition-all disabled:opacity-50">
              Selesaikan Pembayaran & Lunas
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { QrCode as LucideQrCode } from 'lucide-vue-next'
import jsQR from 'jsqr'

definePageMeta({
  middleware: 'admin'
})

const api = useApi()
const orders = ref<any[]>([])
const loading = ref(true)
const filterStatus = ref('')

const scanQuery = ref('')
const selectedOrder = ref<any>(null)
const scannerInput = ref<HTMLInputElement | null>(null)

const scanSuccessBanner = ref(false)
const scanSuccessCode = ref('')

const showPayModal = ref(false)
const activePayOrder = ref<any>(null)
const cashInput = ref<number | ''>('')
const submittingPay = ref(false)

// Camera scanner state
const showCameraModal = ref(false)
const videoRef = ref<HTMLVideoElement | null>(null)
const canvasRef = ref<HTMLCanvasElement | null>(null)
let cameraStream: MediaStream | null = null
let animationFrameId: number | null = null

const formatPrice = (val: number) => {
  return new Intl.NumberFormat('id-ID').format(val || 0)
}

const formatDate = (dateStr: string) => {
  if (!dateStr) return '21/4/2026'
  const d = new Date(dateStr)
  return `${d.getDate()}/${d.getMonth() + 1}/${d.getFullYear()}`
}

const { isDark } = useTheme()

const getStatusBadgeClass = (status: string) => {
  if (isDark.value) {
    switch (status) {
      case 'pending': return 'bg-amber-950/80 text-amber-300 border-amber-600'
      case 'confirmed': return 'bg-sky-950/80 text-sky-300 border-sky-600'
      case 'completed': return 'bg-emerald-950/80 text-emerald-300 border-emerald-600'
      default: return 'bg-slate-800 text-slate-300 border-slate-700'
    }
  }
  switch (status) {
    case 'pending': return 'bg-amber-200 text-amber-950 border-amber-400'
    case 'confirmed': return 'bg-sky-200 text-sky-950 border-sky-400'
    case 'completed': return 'bg-emerald-200 text-emerald-950 border-emerald-400'
    default: return 'bg-slate-200 text-slate-900 border-slate-400'
  }
}

const filteredOrders = computed(() => {
  if (!filterStatus.value) return orders.value
  return orders.value.filter(o => o.status === filterStatus.value)
})

const computedKembalian = computed(() => {
  if (!activePayOrder.value || !cashInput.value) return 0
  return Number(cashInput.value) - Number(activePayOrder.value.total_harga)
})

const fetchOrders = async () => {
  loading.value = true
  try {
    const res = await api.get('/api/orders')
    orders.value = res.data || []
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

const selectOrder = (order: any) => {
  selectedOrder.value = order
}

const handleScanSubmit = async () => {
  const query = scanQuery.value.trim().toLowerCase()
  if (!query) return

  try {
    const res = await api.post('/api/orders/scan', { kode_pesanan: query })
    const matched = res.data

    selectedOrder.value = matched
    scanSuccessCode.value = matched.kode_pesanan
    scanSuccessBanner.value = true
    scanQuery.value = ''
    
    // Play audio beep sound on scan success
    if (process.client) {
      try {
        const audioCtx = new (window.AudioContext || (window as any).webkitAudioContext)()
        const osc = audioCtx.createOscillator()
        const gain = audioCtx.createGain()
        osc.type = 'sine'
        osc.frequency.setValueAtTime(880, audioCtx.currentTime)
        gain.gain.setValueAtTime(0.3, audioCtx.currentTime)
        osc.connect(gain)
        gain.connect(audioCtx.destination)
        osc.start()
        osc.stop(audioCtx.currentTime + 0.15)
      } catch (e) {
        // Ignore audio context errors
      }
    }

    // Alert notification for Admin
    alert(`✅ Scan Berhasil & Tersimpan di Database!\n\nKode Pesanan: ${matched.kode_pesanan}\nPelanggan: ${matched.user_name || matched.pelanggan || 'User'}\nStatus DB: ${matched.status.toUpperCase()}\nTotal: Rp. ${formatPrice(matched.total_harga)}\n\nStatus pesanan otomatis diperbarui di Database ke 'CONFIRMED'. Silakan selesaikan pembayaran & berikan Struk/Invoice kepada pelanggan.`)
    await fetchOrders()
  } catch (err: any) {
    alert(err.data?.message || `Pesanan dengan kode "${scanQuery.value}" tidak ditemukan di Database!`)
  }
}

// Camera Scanner Logic
const startCameraScanner = async () => {
  showCameraModal.value = true
  await nextTick()
  try {
    cameraStream = await navigator.mediaDevices.getUserMedia({
      video: { facingMode: 'environment' }
    })
    if (videoRef.value) {
      videoRef.value.srcObject = cameraStream
      videoRef.value.setAttribute('playsinline', 'true')
      videoRef.value.play()
      requestAnimationFrame(scanVideoFrame)
    }
  } catch (err) {
    alert('Gagal mengakses kamera. Pastikan izin kamera telah diberikan di browser.')
    showCameraModal.value = false
  }
}

const scanVideoFrame = () => {
  if (!showCameraModal.value || !videoRef.value) return

  if (videoRef.value.readyState === videoRef.value.HAVE_ENOUGH_DATA) {
    const video = videoRef.value
    const canvas = canvasRef.value || document.createElement('canvas')
    canvas.width = video.videoWidth
    canvas.height = video.videoHeight
    const ctx = canvas.getContext('2d')
    if (ctx) {
      ctx.drawImage(video, 0, 0, canvas.width, canvas.height)
      const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height)
      const code = jsQR(imageData.data, imageData.width, imageData.height, {
        inversionAttempts: 'dontInvert'
      })

      if (code && code.data) {
        scanQuery.value = code.data
        stopCameraScanner()
        handleScanSubmit()
        return
      }
    }
  }
  animationFrameId = requestAnimationFrame(scanVideoFrame)
}

const stopCameraScanner = () => {
  if (animationFrameId) cancelAnimationFrame(animationFrameId)
  if (cameraStream) {
    cameraStream.getTracks().forEach(track => track.stop())
    cameraStream = null
  }
  showCameraModal.value = false
}

const confirmOrder = async (order: any) => {
  try {
    const res = await api.put(`/api/admin/orders/${order.id}/confirm`)
    alert(res.message || 'Pesanan berhasil dikonfirmasi!')
    await fetchOrders()
    if (selectedOrder.value && selectedOrder.value.id === order.id) {
      selectedOrder.value.status = 'confirmed'
    }
  } catch (err: any) {
    alert(err.data?.message || 'Gagal mengonfirmasi pesanan.')
  }
}

const openPayModal = (order: any) => {
  activePayOrder.value = order
  cashInput.value = order.total_harga
  showPayModal.value = true
}

const processPayment = async () => {
  if (!activePayOrder.value || !cashInput.value) return

  submittingPay.value = true
  try {
    const res = await api.put(`/api/admin/orders/${activePayOrder.value.id}/pay`, {
      cash: cashInput.value
    })
    showPayModal.value = false
    alert(res.message || 'Pembayaran berhasil diselesaikan! Struk / Invoice dapat segera diserahkan kepada pelanggan.')
    await fetchOrders()
    if (selectedOrder.value && selectedOrder.value.id === activePayOrder.value.id) {
      selectedOrder.value.status = 'completed'
      selectedOrder.value.cash = cashInput.value
    }
  } catch (err: any) {
    alert(err.data?.message || 'Gagal memproses pembayaran.')
  } finally {
    submittingPay.value = false
  }
}

const printReceipt = () => {
  window.print()
}

const downloadInvoicePdf = (orderId: number) => {
  const url = `${api.apiBase}/api/orders/${orderId}/invoice-pdf`
  window.open(url, '_blank')
}

// Global listener for USB hardware QR code scanner
let scannerBuffer = ''
let lastKeyTime = Date.now()

const onGlobalKeydown = (e: KeyboardEvent) => {
  const currentTime = Date.now()
  // Hardware scanners type very rapidly (< 50ms per key)
  if (currentTime - lastKeyTime > 100) {
    scannerBuffer = ''
  }
  lastKeyTime = currentTime

  if (e.key === 'Enter') {
    if (scannerBuffer.length > 2) {
      scanQuery.value = scannerBuffer
      handleScanSubmit()
      scannerBuffer = ''
    }
  } else if (e.key.length === 1) {
    scannerBuffer += e.key
  }
}

onMounted(() => {
  fetchOrders()
  if (process.client) {
    window.addEventListener('keydown', onGlobalKeydown)
  }
})

onUnmounted(() => {
  stopCameraScanner()
  if (process.client) {
    window.removeEventListener('keydown', onGlobalKeydown)
  }
})
</script>

<style scoped>
@media print {
  body * {
    visibility: hidden;
  }
  .order-card, .order-card * {
    visibility: visible;
  }
  .order-card {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
  }
}
</style>

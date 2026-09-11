<template>
  <div class="max-w-4xl mx-auto space-y-8">
    <!-- Header Scan / Cari Pesanan untuk User -->
    <div 
      :class="isDark ? 'bg-slate-900 border-slate-800 text-slate-100' : 'bg-white border-slate-800 text-slate-900'"
      class="p-5 rounded-3xl border-2 shadow-sm flex flex-col md:flex-row items-center justify-between gap-4 transition-colors duration-300"
    >
      <div class="flex items-center gap-2 w-full md:w-auto flex-1">
        <div class="relative w-full max-w-md">
          <input 
            v-model="scanQuery" 
            type="text" 
            placeholder="Scan QR Code / Masukkan Kode (A021)..." 
            :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500 focus:bg-slate-900' : 'bg-slate-50 border-slate-800 text-slate-900 focus:bg-white'"
            class="w-full pl-10 pr-4 py-3 rounded-full border-2 text-sm font-extrabold focus:ring-2 focus:ring-indigo-500 outline-none transition-colors"
            @keyup.enter="handleUserScanSubmit"
          />
          <LucideQrCode class="w-5 h-5 text-indigo-500 absolute left-3.5 top-3.5" />
        </div>
        <button 
          @click="startCameraScanner" 
          class="px-4 py-3 bg-indigo-600 hover:bg-indigo-700 text-white rounded-full font-black text-xs border-2 border-slate-900 shadow-md flex items-center gap-1.5 whitespace-nowrap transition-transform active:scale-95"
        >
          📷 Scan Kamera HP
        </button>
      </div>

      <div 
        :class="isDark ? 'bg-slate-950 border-slate-800 text-slate-300' : 'bg-slate-100 border-slate-300 text-slate-700'"
        class="text-xs font-black uppercase px-3.5 py-2 rounded-xl border"
      >
        Total: {{ orders.length }} Pesanan
      </div>
    </div>

    <!-- Modal Scanner Kamera HP / Web -->
    <div v-if="showCameraModal" class="fixed inset-0 bg-slate-950/85 backdrop-blur-md z-50 flex items-center justify-center p-4">
      <div 
        :class="isDark ? 'bg-slate-900 border-slate-700 text-white' : 'bg-white border-slate-900 text-slate-900'"
        class="rounded-3xl p-6 max-w-md w-full shadow-2xl border-4 space-y-4 text-center relative overflow-hidden"
      >
        <div class="flex justify-between items-center border-b-2 border-slate-800 pb-3">
          <h3 class="font-black text-lg flex items-center gap-2">
            📷 Pemindai Kamera QR Code
          </h3>
          <button @click="stopCameraScanner" :class="isDark ? 'bg-slate-800 text-slate-300' : 'bg-slate-100 text-slate-700'" class="text-xs font-black px-3 py-1.5 rounded-xl border border-slate-700">
            ✕ Tutup Kamera
          </button>
        </div>

        <div class="relative aspect-square w-full bg-slate-950 rounded-2xl overflow-hidden border-2 border-slate-800 flex items-center justify-center">
          <video ref="videoRef" class="w-full h-full object-cover"></video>
          <canvas ref="canvasRef" class="hidden"></canvas>
          <div class="absolute inset-0 border-4 border-dashed border-emerald-400/80 m-10 rounded-2xl pointer-events-none animate-pulse flex items-center justify-center">
            <span class="text-white text-xs font-extrabold bg-slate-900/90 px-3 py-1 rounded-full border border-emerald-400">Arahkan QR ke Sini</span>
          </div>
        </div>

        <p class="text-xs font-extrabold" :class="isDark ? 'text-slate-400' : 'text-slate-600'">Arahkan kamera HP ke QR Code pesanan untuk memindai otomatis.</p>
      </div>
    </div>

    <!-- Banner Notifikasi Scan Berhasil untuk User -->
    <div v-if="scanSuccessBanner" class="bg-emerald-600 border-4 border-slate-900 text-white p-5 rounded-3xl shadow-lg flex items-center justify-between gap-4 animate-bounce">
      <div class="flex items-center gap-3">
        <span class="text-3xl">✅</span>
        <div>
          <h3 class="font-black text-lg tracking-wide uppercase text-yellow-300">Scan QR Code Berhasil Terdeteksi!</h3>
          <p class="text-xs font-bold">
            Kode Pesanan: <span class="font-mono underline text-white font-black">{{ scanSuccessCode }}</span> ditemukan dalam Riwayat Anda. Status berhasil di-update!
          </p>
        </div>
      </div>
      <button @click="scanSuccessBanner = false" class="bg-slate-900 text-white hover:bg-slate-800 font-extrabold text-xs px-3.5 py-2 rounded-xl border border-white">
        ✕ Tutup Notifikasi
      </button>
    </div>

    <div v-if="loading" class="text-center py-16 font-semibold" :class="isDark ? 'text-slate-400' : 'text-slate-500'">
      Memuat riwayat pesanan...
    </div>

    <div 
      v-else-if="orders.length === 0" 
      :class="isDark ? 'bg-slate-900 border-slate-800 text-slate-200' : 'bg-white border-slate-300 text-slate-800'"
      class="text-center py-16 rounded-3xl border-2 shadow-sm"
    >
      <div class="text-5xl mb-3">📦</div>
      <h3 class="font-extrabold text-lg">Belum Ada Pesanan</h3>
      <p class="text-xs text-slate-400 mt-1 mb-6">Anda belum melakukan pesanan buku.</p>
      <NuxtLink to="/user/katalog" class="px-6 py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-extrabold shadow-md">
        Mulai Belanja &rarr;
      </NuxtLink>
    </div>

    <div v-else class="space-y-8 print:space-y-0">
      <div 
        v-for="order in orders" 
        :key="order.id" 
        :id="'order-card-' + order.kode_pesanan"
        :class="highlightedOrderCode === order.kode_pesanan ? 'ring-4 ring-emerald-500 scale-[1.01]' : ''"
        class="order-card space-y-4 transition-all duration-300"
      >
        <!-- Card Container matching Mockup -->
        <div 
          :class="isDark ? 'bg-slate-900 border-slate-700 text-slate-100' : 'bg-gradient-to-r from-emerald-100 via-sky-100 to-indigo-200 border-slate-800 text-slate-900'"
          class="border-2 rounded-3xl p-6 shadow-md relative transition-colors duration-300"
        >
          <!-- Card Title -->
          <div class="flex items-center justify-between mb-4">
            <h2 class="text-2xl font-black font-serif tracking-tight" :class="isDark ? 'text-white' : 'text-slate-900'">
              Kode Pesanan : <span class="font-mono text-indigo-400 uppercase">{{ order.kode_pesanan }}</span>
            </h2>
            <span :class="getStatusBadgeClass(order.status)" class="text-xs font-black uppercase px-3 py-1 rounded-full border">
              {{ order.status }}
            </span>
          </div>

          <!-- Alert Petunjuk Pembeli -->
          <div 
            :class="isDark ? 'bg-slate-950/80 border-slate-800 text-slate-300' : 'bg-white/80 border-slate-800 text-slate-800'"
            class="border-2 p-3 rounded-2xl mb-4 text-xs font-bold flex items-center gap-2"
          >
            <span class="text-lg">📢</span>
            <span>Tunjukkan QR Code di bawah kepada Kasir/Admin. Setelah di-scan & berhasil dicatat, mohon tunggu Struk / Invoice diserahkan langsung oleh Admin.</span>
          </div>

          <!-- Content Grid: Table + QR Code -->
          <div class="grid grid-cols-1 lg:grid-cols-4 gap-6 items-center">
            <!-- Table Section -->
            <div class="lg:col-span-3 overflow-x-auto">
              <table 
                :class="isDark ? 'bg-slate-950 border-slate-800 text-slate-200' : 'bg-white/70 border-slate-900 text-slate-900'"
                class="w-full text-center border-collapse border-2 backdrop-blur-sm"
              >
                <thead>
                  <tr :class="isDark ? 'bg-slate-800 text-slate-200 border-slate-700' : 'bg-slate-200/90 text-slate-900 border-slate-900'" class="font-black text-xs border-b-2">
                    <th class="p-2 border-r-2 border-slate-700">Judul Buku</th>
                    <th class="p-2 border-r-2 border-slate-700">Tanggal Pembelian</th>
                    <th class="p-2 border-r-2 border-slate-700">Jumlah Pesanan</th>
                    <th class="p-2 border-r-2 border-slate-700">Harga Satuan</th>
                    <th class="p-2">Total Harga</th>
                  </tr>
                </thead>
                <tbody class="divide-y-2 divide-slate-800 text-xs font-bold">
                  <tr v-for="detail in (order.details || order.items || [])" :key="detail.id">
                    <td class="p-2.5 border-r-2 border-slate-800 text-left px-4 font-extrabold">{{ detail.buku?.judul || detail.nama_buku }}</td>
                    <td class="p-2.5 border-r-2 border-slate-800">{{ formatDate(order.created_at) }}</td>
                    <td class="p-2.5 border-r-2 border-slate-800 font-extrabold">{{ detail.qty }}</td>
                    <td class="p-2.5 border-r-2 border-slate-800">Rp.{{ formatPrice(detail.harga_satuan) }}</td>
                    <td class="p-2.5 font-extrabold">Rp.{{ formatPrice(detail.subtotal) }}</td>
                  </tr>
                  <!-- Total Summary Row -->
                  <tr :class="isDark ? 'bg-slate-800 border-slate-700 text-white' : 'bg-slate-200/90 border-slate-900 text-slate-900'" class="font-black text-sm border-t-2">
                    <td colspan="5" class="p-3 text-center">
                      Total Harga : Rp. {{ formatPrice(order.total_harga) }}
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <!-- QR Code Section -->
            <div 
              :class="isDark ? 'bg-slate-950 border-slate-800' : 'bg-white/80 border-slate-900'"
              class="lg:col-span-1 flex flex-col items-center justify-center p-2 rounded-2xl border-2 shadow-sm"
            >
              <QrCodeDisplay :value="order.kode_pesanan" :size="150" show-label />
              <p class="text-[10px] text-slate-400 font-bold text-center mt-1">
                Tunjukkan QR ke Kasir
              </p>
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="flex gap-3 print:hidden">
          <button 
            @click="printReceipt" 
            :class="isDark ? 'bg-slate-800 hover:bg-slate-700 text-white border-slate-700' : 'bg-gradient-to-r from-emerald-200 via-sky-200 to-indigo-200 text-slate-900 border-slate-800'"
            class="flex-1 border-2 font-black text-base py-3 rounded-2xl shadow-md transition-transform hover:scale-[1.01] active:scale-95 flex items-center justify-center gap-2"
          >
            <LucidePrinter class="w-5 h-5" />
            <span>Print Struk</span>
          </button>
          
          <button 
            @click="downloadInvoicePdf(order.id)" 
            class="flex-1 bg-indigo-600 hover:bg-indigo-700 border-2 border-slate-800 text-white font-black text-base py-3 rounded-2xl shadow-md transition-transform hover:scale-[1.01] active:scale-95 flex items-center justify-center gap-2"
          >
            <LucideFileText class="w-5 h-5" />
            <span>Unduh Invoice PDF</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Printer as LucidePrinter, FileText as LucideFileText, QrCode as LucideQrCode } from 'lucide-vue-next'
import jsQR from 'jsqr'

definePageMeta({
  middleware: 'auth'
})

const api = useApi()
const orders = ref<any[]>([])
const loading = ref(true)
let pollTimer: any = null

const scanQuery = ref('')
const scanSuccessBanner = ref(false)
const scanSuccessCode = ref('')
const highlightedOrderCode = ref('')

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
    case 'pending':
      return 'bg-amber-200 text-amber-950 border-amber-400'
    case 'confirmed':
      return 'bg-sky-200 text-sky-950 border-sky-400'
    case 'completed':
      return 'bg-emerald-200 text-emerald-950 border-emerald-400'
    default:
      return 'bg-slate-200 text-slate-900 border-slate-400'
  }
}

const printReceipt = () => {
  window.print()
}

const downloadInvoicePdf = (orderId: number) => {
  const url = `${api.apiBase}/api/orders/${orderId}/invoice-pdf`
  window.open(url, '_blank')
}

const fetchOrders = async (silent = false) => {
  if (!silent) loading.value = true
  try {
    const res = await api.get('/api/orders')
    orders.value = res.data || []
  } catch (e) {
    console.error(e)
  } finally {
    if (!silent) loading.value = false
  }
}

const handleUserScanSubmit = async () => {
  const query = scanQuery.value.trim().toLowerCase()
  if (!query) return

  try {
    const res = await api.post('/api/orders/scan', { kode_pesanan: query })
    const matched = res.data

    scanSuccessCode.value = matched.kode_pesanan
    scanSuccessBanner.value = true
    highlightedOrderCode.value = matched.kode_pesanan
    scanQuery.value = ''

    // Play audio beep sound
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
        // Ignore audio errors
      }
    }

    // Scroll to order element
    if (process.client) {
      setTimeout(() => {
        const el = document.getElementById('order-card-' + matched.kode_pesanan)
        if (el) el.scrollIntoView({ behavior: 'smooth', block: 'center' })
      }, 100)
    }

    alert(`✅ Scan Berhasil & Status Diperbarui!\n\nKode Pesanan: ${matched.kode_pesanan}\nStatus Terbaru DB: ${matched.status.toUpperCase()}\nTotal: Rp. ${formatPrice(matched.total_harga)}\n\nStatus pesanan berhasil diubah di Database menjadi 'CONFIRMED'. Silakan tunjukkan ke Kasir untuk cetak Struk/Invoice!`)
    await fetchOrders()
  } catch (err: any) {
    alert(err.data?.message || `Pesanan dengan kode "${scanQuery.value}" tidak ditemukan dalam Riwayat Anda!`)
  }
}

// Camera Scanner Logic for User Page
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
        handleUserScanSubmit()
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

// Global listener for USB hardware QR code scanner on User page
let scannerBuffer = ''
let lastKeyTime = Date.now()

const onGlobalKeydown = (e: KeyboardEvent) => {
  const currentTime = Date.now()
  if (currentTime - lastKeyTime > 100) {
    scannerBuffer = ''
  }
  lastKeyTime = currentTime

  if (e.key === 'Enter') {
    if (scannerBuffer.length > 2) {
      scanQuery.value = scannerBuffer
      handleUserScanSubmit()
      scannerBuffer = ''
    }
  } else if (e.key.length === 1) {
    scannerBuffer += e.key
  }
}

onMounted(() => {
  fetchOrders()
  // Poll every 5s so when admin scans & updates status, user sees update live
  pollTimer = setInterval(() => {
    fetchOrders(true)
  }, 5000)

  if (process.client) {
    window.addEventListener('keydown', onGlobalKeydown)
  }
})

onUnmounted(() => {
  if (pollTimer) clearInterval(pollTimer)
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


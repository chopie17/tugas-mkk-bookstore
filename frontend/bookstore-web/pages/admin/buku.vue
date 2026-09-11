<template>
  <div class="space-y-6">
    <!-- Header -->
    <div
      :class="isDark ? 'bg-slate-900 border-slate-800 text-slate-100' : 'bg-white border-slate-200 text-slate-900'"
      class="p-5 rounded-2xl border flex flex-col sm:flex-row sm:items-center justify-between gap-4 shadow-sm"
    >
      <div>
        <h1 :class="isDark ? 'text-white' : 'text-slate-900'" class="text-2xl font-black font-serif tracking-tight">
          Manajemen Buku
        </h1>
        <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-xs mt-1">
          Kelola koleksi buku toko. Nama buku harus unik.
        </p>
      </div>
      <button
        @click="openCreateModal"
        class="px-5 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-black shadow-md transition-all active:scale-95 whitespace-nowrap"
      >
        + Tambah Buku
      </button>
    </div>

    <!-- Books Table -->
    <div
      :class="isDark ? 'bg-slate-900 border-slate-800' : 'bg-white border-slate-200'"
      class="rounded-2xl border overflow-hidden shadow-sm"
    >
      <div v-if="loading" :class="isDark ? 'text-slate-500' : 'text-slate-400'" class="text-center py-14 text-sm font-semibold">
        Memuat data buku...
      </div>
      <div v-else-if="books.length === 0" :class="isDark ? 'text-slate-500' : 'text-slate-400'" class="text-center py-14 text-sm">
        <div class="text-4xl mb-2">📚</div>
        Belum ada buku terdaftar.
      </div>
      <div v-else class="overflow-x-auto">
        <table class="w-full text-left text-xs">
          <thead>
            <tr :class="isDark ? 'bg-slate-800 text-slate-300 border-slate-700' : 'bg-slate-50 text-slate-600 border-slate-200'" class="border-b font-black uppercase text-[10px] tracking-wider">
              <th class="px-4 py-3">Cover</th>
              <th class="px-4 py-3">Judul Buku</th>
              <th class="px-4 py-3">Kategori</th>
              <th class="px-4 py-3">Tgl / Thn Terbit</th>
              <th class="px-4 py-3">Stok</th>
              <th class="px-4 py-3">Harga Modal</th>
              <th class="px-4 py-3">Harga Jual</th>
              <th class="px-4 py-3">Keuntungan</th>
              <th class="px-4 py-3 text-right">Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="book in books"
              :key="book.id"
              :class="isDark ? 'border-slate-800 hover:bg-slate-800/50' : 'border-slate-100 hover:bg-slate-50'"
              class="border-b last:border-b-0 transition-colors"
            >
              <td class="px-4 py-3">
                <div :class="isDark ? 'bg-slate-800' : 'bg-slate-100'" class="w-10 h-12 rounded-lg overflow-hidden flex items-center justify-center shrink-0">
                  <img v-if="book.gambar" :src="book.gambar" :alt="book.nama_buku" class="w-full h-full object-cover" />
                  <span v-else class="text-lg">📕</span>
                </div>
              </td>
              <td :class="isDark ? 'text-white' : 'text-slate-900'" class="px-4 py-3 font-bold max-w-[160px] truncate">
                {{ book.nama_buku }}
              </td>
              <td class="px-4 py-3">
                <span :class="isDark ? 'bg-indigo-900/60 text-indigo-300' : 'bg-indigo-50 text-indigo-700'" class="px-2.5 py-1 rounded-full font-semibold text-[10px]">
                  {{ book.category_name || 'Buku' }}
                </span>
              </td>
              <td :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="px-4 py-3 whitespace-nowrap">
                {{ book.tanggal_terbit || '-' }}
                <span :class="isDark ? 'text-slate-500' : 'text-slate-400'" class="text-[10px]"> ({{ book.tahun_terbit }})</span>
              </td>
              <td class="px-4 py-3 font-bold" :class="book.stok > 0 ? (isDark ? 'text-slate-200' : 'text-slate-800') : 'text-rose-500'">
                {{ book.stok }}
              </td>
              <td :class="isDark ? 'text-slate-300' : 'text-slate-600'" class="px-4 py-3 whitespace-nowrap">
                Rp {{ formatNumber(book.harga_modal) }}
              </td>
              <td :class="isDark ? 'text-white' : 'text-slate-900'" class="px-4 py-3 font-bold whitespace-nowrap">
                Rp {{ formatNumber(book.harga_jual) }}
              </td>
              <td class="px-4 py-3 font-bold whitespace-nowrap" :class="isDark ? 'text-emerald-400' : 'text-emerald-600'">
                Rp {{ formatNumber(book.keuntungan) }}
              </td>
              <td class="px-4 py-3 text-right">
                <div class="flex items-center justify-end gap-2">
                  <button
                    @click="openEditModal(book)"
                    :class="isDark ? 'bg-amber-900/40 text-amber-400 hover:bg-amber-900/70' : 'bg-amber-50 text-amber-700 hover:bg-amber-100'"
                    class="px-3 py-1.5 rounded-lg font-semibold transition-colors"
                  >
                    Edit
                  </button>
                  <button
                    @click="deleteBook(book)"
                    :class="isDark ? 'bg-rose-900/40 text-rose-400 hover:bg-rose-900/70' : 'bg-rose-50 text-rose-700 hover:bg-rose-100'"
                    class="px-3 py-1.5 rounded-lg font-semibold transition-colors"
                  >
                    Hapus
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal Form -->
    <div v-if="showModal" class="fixed inset-0 bg-slate-950/70 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div
        :class="isDark ? 'bg-slate-900 border-slate-700 text-slate-100' : 'bg-white border-slate-200 text-slate-900'"
        class="rounded-2xl p-6 max-w-xl w-full shadow-2xl border space-y-4 max-h-[90vh] overflow-y-auto"
      >
        <div class="flex items-center justify-between">
          <h3 :class="isDark ? 'text-white' : 'text-slate-900'" class="font-black text-lg">
            {{ isEdit ? '✏️ Edit Buku' : '➕ Tambah Buku Baru' }}
          </h3>
          <button
            @click="showModal = false"
            :class="isDark ? 'bg-slate-800 text-slate-400 hover:text-slate-200' : 'bg-slate-100 text-slate-500 hover:text-slate-700'"
            class="w-8 h-8 flex items-center justify-center rounded-lg text-sm font-black"
          >
            ✕
          </button>
        </div>

        <div v-if="errorMessage" class="p-3 rounded-xl bg-rose-500/10 border border-rose-500/30 text-rose-400 text-xs font-medium">
          {{ errorMessage }}
        </div>

        <form @submit.prevent="saveBook" class="space-y-4">
          <div>
            <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">
              Judul Buku <span class="text-rose-500">*</span>
            </label>
            <input
              v-model="form.nama_buku"
              type="text"
              required
              :class="isDark ? 'bg-slate-800 border-slate-700 text-white placeholder-slate-500 focus:bg-slate-750' : 'bg-slate-50 border-slate-300 text-slate-900 focus:bg-white'"
              class="w-full px-4 py-2.5 text-xs rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none transition-colors"
              placeholder="Masukkan judul buku yang unik"
            />
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Kategori <span class="text-rose-500">*</span></label>
              <select
                v-model="form.category_id"
                required
                :class="isDark ? 'bg-slate-800 border-slate-700 text-white' : 'bg-slate-50 border-slate-300 text-slate-900'"
                class="w-full px-4 py-2.5 text-xs rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none transition-colors"
              >
                <option value="">-- Pilih Kategori --</option>
                <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.nama_kategori }}</option>
              </select>
            </div>

            <div>
              <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Tanggal Terbit <span class="text-rose-500">*</span></label>
              <input
                v-model="form.tanggal_terbit"
                type="date"
                required
                :class="isDark ? 'bg-slate-800 border-slate-700 text-white' : 'bg-slate-50 border-slate-300 text-slate-900'"
                class="w-full px-4 py-2.5 text-xs rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none transition-colors"
              />
              <span v-if="computedTahun" class="text-[10px] text-indigo-400 font-semibold mt-1 block">
                Tahun terbit: {{ computedTahun }}
              </span>
            </div>
          </div>

          <div class="grid grid-cols-3 gap-4">
            <div>
              <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Stok</label>
              <input
                v-model.number="form.stok"
                type="number"
                min="0"
                required
                :class="isDark ? 'bg-slate-800 border-slate-700 text-white' : 'bg-slate-50 border-slate-300 text-slate-900'"
                class="w-full px-3 py-2.5 text-xs rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none"
              />
            </div>
            <div>
              <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Harga Modal</label>
              <input
                v-model.number="form.harga_modal"
                type="number"
                min="0"
                required
                :class="isDark ? 'bg-slate-800 border-slate-700 text-white' : 'bg-slate-50 border-slate-300 text-slate-900'"
                class="w-full px-3 py-2.5 text-xs rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none"
              />
            </div>
            <div>
              <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Harga Jual</label>
              <input
                v-model.number="form.harga_jual"
                type="number"
                min="0"
                required
                :class="isDark ? 'bg-slate-800 border-slate-700 text-white' : 'bg-slate-50 border-slate-300 text-slate-900'"
                class="w-full px-3 py-2.5 text-xs rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none"
              />
            </div>
          </div>

          <!-- Profit Preview -->
          <div :class="isDark ? 'bg-indigo-950/50 border-indigo-800/50' : 'bg-indigo-50 border-indigo-100'" class="p-3 rounded-xl border text-xs flex justify-between items-center font-semibold">
            <span :class="isDark ? 'text-indigo-300' : 'text-indigo-900'">Keuntungan Otomatis (Jual - Modal):</span>
            <span class="text-emerald-500 text-sm font-black">Rp {{ formatNumber(computedKeuntungan) }}</span>
          </div>

          <div>
            <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Deskripsi Buku</label>
            <textarea
              v-model="form.deskripsi"
              rows="3"
              :class="isDark ? 'bg-slate-800 border-slate-700 text-white placeholder-slate-500' : 'bg-slate-50 border-slate-300 text-slate-900'"
              class="w-full px-4 py-2.5 text-xs rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none resize-none transition-colors"
              placeholder="Ringkasan atau deskripsi buku..."
            />
          </div>

          <div>
            <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Gambar / Cover Buku</label>
            <input
              @change="handleFileChange"
              type="file"
              accept="image/*"
              :class="isDark ? 'text-slate-400 file:bg-slate-800 file:text-slate-300 file:border-slate-700' : 'text-slate-500 file:bg-indigo-50 file:text-indigo-700'"
              class="w-full text-xs file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border file:text-xs file:font-semibold file:cursor-pointer"
            />
          </div>

          <div :class="isDark ? 'border-slate-800' : 'border-slate-100'" class="flex justify-end gap-3 pt-2 border-t">
            <button
              type="button"
              @click="showModal = false"
              :class="isDark ? 'text-slate-400 hover:bg-slate-800' : 'text-slate-600 hover:bg-slate-100'"
              class="px-4 py-2 text-xs font-semibold rounded-xl transition-colors"
            >
              Batal
            </button>
            <button
              type="submit"
              :disabled="submitting"
              class="px-5 py-2 text-xs font-black text-white bg-indigo-600 hover:bg-indigo-700 rounded-xl shadow-md transition-all disabled:opacity-50 disabled:cursor-not-allowed active:scale-95"
            >
              {{ submitting ? 'Menyimpan...' : 'Simpan Buku' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: 'admin'
})

const api = useApi()
const { isDark } = useTheme()
const books = ref<any[]>([])
const categories = ref<any[]>([])
const loading = ref(true)
const showModal = ref(false)
const isEdit = ref(false)
const editId = ref<number | null>(null)
const submitting = ref(false)
const errorMessage = ref('')
const selectedGambar = ref<File | null>(null)

const form = reactive({
  nama_buku: '',
  category_id: '',
  tanggal_terbit: '',
  stok: 0,
  harga_modal: 0,
  harga_jual: 0,
  deskripsi: ''
})

const formatNumber = (val: number) => {
  return new Intl.NumberFormat('id-ID').format(val || 0)
}

const computedKeuntungan = computed(() => {
  const profit = (Number(form.harga_jual) || 0) - (Number(form.harga_modal) || 0)
  return profit > 0 ? profit : 0
})

const computedTahun = computed(() => {
  if (!form.tanggal_terbit) return ''
  return new Date(form.tanggal_terbit).getFullYear()
})

const fetchBooks = async () => {
  loading.value = true
  try {
    const res = await api.get('/api/books')
    books.value = res.data || []
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

const fetchCategories = async () => {
  try {
    const res = await api.get('/api/categories')
    categories.value = res.data || []
  } catch (e) {}
}

const handleFileChange = (e: Event) => {
  const target = e.target as HTMLInputElement
  if (target.files && target.files[0]) {
    selectedGambar.value = target.files[0]
  }
}

const openCreateModal = () => {
  isEdit.value = false
  editId.value = null
  form.nama_buku = ''
  form.category_id = ''
  form.tanggal_terbit = ''
  form.stok = 10
  form.harga_modal = 50000
  form.harga_jual = 75000
  form.deskripsi = ''
  selectedGambar.value = null
  errorMessage.value = ''
  showModal.value = true
}

const openEditModal = (b: any) => {
  isEdit.value = true
  editId.value = b.id
  form.nama_buku = b.nama_buku
  form.category_id = b.category_id
  form.tanggal_terbit = b.tanggal_terbit
  form.stok = b.stok
  form.harga_modal = b.harga_modal
  form.harga_jual = b.harga_jual
  form.deskripsi = b.deskripsi || ''
  selectedGambar.value = null
  errorMessage.value = ''
  showModal.value = true
}

const saveBook = async () => {
  submitting.value = true
  errorMessage.value = ''

  try {
    const formData = new FormData()
    formData.append('nama_buku', form.nama_buku)
    formData.append('category_id', String(form.category_id))
    formData.append('tanggal_terbit', form.tanggal_terbit)
    formData.append('stok', String(form.stok))
    formData.append('harga_modal', String(form.harga_modal))
    formData.append('harga_jual', String(form.harga_jual))
    formData.append('deskripsi', form.deskripsi)
    if (selectedGambar.value) {
      formData.append('gambar', selectedGambar.value)
    }

    if (isEdit.value && editId.value) {
      formData.append('_method', 'PUT')
      await api.post(`/api/admin/books/${editId.value}`, formData)
    } else {
      await api.post('/api/admin/books', formData)
    }

    showModal.value = false
    await fetchBooks()
  } catch (err: any) {
    errorMessage.value = err.data?.message || err.data?.errors?.nama_buku?.[0] || 'Gagal menyimpan data buku.'
  } finally {
    submitting.value = false
  }
}

const deleteBook = async (b: any) => {
  if (!confirm(`Yakin ingin menghapus buku '${b.nama_buku}'?`)) return
  try {
    await api.delete(`/api/admin/books/${b.id}`)
    await fetchBooks()
  } catch (err: any) {
    alert(err.data?.message || 'Gagal menghapus buku.')
  }
}

onMounted(async () => {
  await fetchCategories()
  await fetchBooks()
})
</script>

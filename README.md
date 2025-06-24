# Digital Signal Processing – CEID Exercises

This repository contains solutions and analyses for the five assigned exercises in the “Applications of Digital Signal Processing” course (CEID, Univ. of Patras). Each exercise is self‑contained in its own folder and comes with accompanying MATLAB/Python code, plots, and write‑ups.

---


## Exercise 1 – Spectral Content Estimation  
**Topic:** Pisarenko’s method for estimating sinusoidal frequencies and noise variance by eigen‑analysis of the autocorrelation matrix.  

**Key Steps & Analysis:**  
1. **Theory Recap**  
   - Model the signal as  
     $$X(n) = \sum_{i=1}^{P} A_i\,e^{j\omega_i n} + W(n)\,. $$  
   - Form the autocorrelation matrix  
     $$R_{XX} = E\bigl[X(n)\,X(n)^H\bigr]$$  
     and observe that the signal subspace is spanned by the eigenvectors corresponding to the largest \(P\) eigenvalues, while the noise subspace corresponds to the remaining equal, smallest eigenvalues.

2. **Algorithm (Pisarenko)**  
   - Compute eigenvalues  
     $$\lambda_1 \ge \lambda_2 \ge \cdots \ge \lambda_M\,. $$  
   - Estimate noise variance  
     $$\hat\sigma_W^2 = \lambda_{\min} = \lambda_M\,. $$  
   - For each sinusoid, estimate its power  
     $$|A_i|^2 = \frac{\lambda_i - \lambda_M}{M},\quad i=1,\dots,P\,. $$  
   - Recover each frequency \(\omega_i\) from the phase progression of the corresponding principal eigenvector.

3. **Implementation & Results**  
   - **Part 5:** Closed‑form example with a \(2\times2\) autocorrelation matrix.  
   - **Part 7:** Monte Carlo simulation (\(N=100\) realizations, \(M=50\)); estimate sample autocorrelation, compute eigenstructure, plot histogram of noise‑subspace eigenvalues, compare empirical moments to theory.  
   - **Discussion:** Convergence of sample estimates to their theoretical values; effect of \(M\) and \(N\) on estimator variance; bias‑variance trade‑offs in frequency estimation.

---

## Exercise 2 – Low‑Rank Modeling & Eigenfilters  
**Topic:** Low‑rank approximation of multidimensional signals via eigenfilter decomposition (Karhunen–Loève, PCA/SVD).  

**Key Steps & Analysis:**  
1. **Modeling**  
   - Represent a vector random process \(U\) with covariance  
     $$C_{UU} = Q\,\Lambda\,Q^T\,. $$  
   - Transmit only the top \(P\) principal components for compression.

2. **Noiseless vs. Noisy Channel**  
   - In the noise‑free case, reconstruction MSE is  
     $$\text{MSE} = \sum_{m=P+1}^{M} \lambda_m\,. $$  
   - Over an AWGN channel, show  
     $$\text{MSE} = \sum_{m=P+1}^{M} \lambda_m \;+\; P\,\sigma_W^2\,. $$

3. **Simulation**  
   - Load `U.mat` (100 realizations, \(M=10\,000\)).  
   - Estimate \(C_{UU}\); perform `eig` or `svd`; verify theoretical error curves vs. \(P\).  
   - Plot relative error vs. \(P\) for various channel SNRs; discuss regimes where low‑rank transmission is beneficial.

---

## Exercise 3 – Dictionary Learning & Sparse Coding (KSVD + Inpainting)  
**Topic:** KSVD algorithm for dictionary learning and sparse coding (Generalized OMP), plus applications to denoising & inpainting.  

**Key Steps & Analysis:**  
1. **KSVD & GenOMP**  
   - **Sparse Coding (P1):**  
     $$\min_X \|Y - D\,X\|_F^2 \quad\text{s.t.}\quad \|x_n\|_0 \le T,$$  
     solved via greedy atom selection (OMP).  
   - **Dictionary Update (P2):**  
     Update each atom by computing the SVD of the residual matrix restricted to the support of that atom.  

2. **Applications**  
   - **Denoising:** Represent noisy image patches with the learned dictionary and reconstruct the denoised image.  
   - **Inpainting:** Fill in missing pixels by sparse approximation on the known support.

3. **Implementation & Results**  
   - MATLAB (and Python bonus) code for both tasks.  
   - Side‑by‑side plots of original, degraded, and recovered images.  
   - Table of MSE vs. SNR for denoising and inpainting; discussion of how dictionary quality and sparsity level affect performance.

---

## Exercise 4 – PCA, LDA & K‑Means for Face Recognition  
**Topic:** Eigenfaces (PCA), Fisherfaces (LDA), and K‑means clustering for face classification.  

**Key Steps & Analysis:**  
1. **PCA (Eigenfaces):**  
   - Vectorize face images into columns; compute the mean face \(\mu\); form covariance  
     $$C = \frac{1}{N}\sum_{n=1}^N (x_n - \mu)(x_n - \mu)^T\,, $$  
     project onto the top \(k\) eigenvectors.

2. **LDA (Fisherfaces):**  
   - Compute within‑class scatter \(S_W\) and between‑class scatter \(S_B\).  
   - Solve  
     $$\max_w \frac{w^T S_B w}{w^T S_W w}$$  
     to find the most discriminant directions.

3. **K‑Means Clustering:**  
   - Cluster the projected feature vectors into \(K\) groups by minimizing within‑cluster variance.

4. **Results & Discussion:**  
   - Reconstruction error vs. retained PCA dimensions.  
   - Classification accuracy: PCA vs. LDA.  
   - Effect of \(K\) on unsupervised grouping; cluster purity analysis.

---

## Exercise 5 – ADSP 21: SVD & PCA on Video Data  
**Topic:** Singular Value Decomposition (SVD) and Principal Component Analysis (PCA) applied to video frames.  

**Key Steps & Analysis:**  
1. **Data Preparation:**  
   - Stack each video frame as a column of  
     $$X \in \mathbb{R}^{T \times N}\,. $$

2. **SVD:**  
   - Compute  
     $$X = U\,\Sigma\,V^T\,, $$  
     interpret singular values \(\sigma_i\) as the energy in each principal mode.  
   - Truncate to the top 10 modes; reconstruct and measure the reconstruction error.

3. **PCA on Covariance:**  
   - Compute the covariance \(X\,X^T\); compare its eigenvalues and truncation performance to the SVD approach.

4. **Feature Extraction & Clustering:**  
   - Project frames onto the top 3 principal components; visualize clustering in 3D.  
   - Present scree plot of variance explained.

5. **Discussion:**  
   - Trade‑off between compression (number of modes) and fidelity.  
   - Applications to background subtraction and dynamic scene modelling.

---

### How to Reproduce

1. **Prerequisites:**  
   - MATLAB R2021a or later (or Python 3.8+ with NumPy/SciPy).  
2. **Run all examples:**  
   ```sh
   cd Exercise-*
   matlab -batch "run_all"    # or python run_all.py




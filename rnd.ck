int nums[100];

for (0 => int i; i < nums.cap(); i++) {
	randWeight([70, 80]) => nums[i];
}

int counts[0];

for (0 => int i; i < nums.cap(); i++) {
	counts[Std.itoa(nums[i])]++;
}

for (0 => int i; i < nums.cap(); i++) {
	<<< counts[Std.itoa(i)]++ >>>;
}





fun int randWeight(int weights[]) {
	0 => int sum;
	for (0 => int i; i < weights.cap(); i++) {
		weights[i] +=> sum;
	}
	Math.random2(0, sum) => int rnd;

	for(0 => int i; i < weights.cap(); i++) {
		if(rnd < weights[i])
			return i;
		weights[i] -=> rnd;
	}

	return 0;
}